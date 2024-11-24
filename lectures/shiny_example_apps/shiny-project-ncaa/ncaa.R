library(shiny)
library(tidyverse)
library(lubridate)

ncaa <- read_csv("https://datasets.stats306.org/ncaa.csv.gz")

ui <- fluidPage(
  titlePanel("NCAA Data"),
  
  sidebarLayout(
    
    sidebarPanel(
      # add brief explanation for app usage 
      helpText("Summarize and visualize the NCAA data from 1985 to 2016"), 
      
      fluidRow(
        column(12,
               # Year range
               sliderInput("years", label = "Year Range", min = 1985,
                           max = 2016, value = c(1990, 2010))
        )
      ),
      
      fluidRow(
        # Team select in two ways
        column(6, # column width must be between 1 and 12
               selectizeInput(
                 inputId = "team1", 
                 label = "Search Team",
                 choices = unique(c(ncaa$Winner,  ncaa$Loser)),
                 options = list(
                   placeholder = "Search Team",
                   maxItems = '1'
                 ),
                 selected = "Michigan"
               )
        ),
        
        column(6, 
               selectInput("team2", label = "Select Team", choices = unique(c(ncaa$Winner,  ncaa$Loser)),
                           selected = "Michigan")
        ),
        
        column(4,
               radioButtons("team_choice", label = "Which team",
                            choices = list("Search Team" = "T1", "Select Team" = "T2"), 
                            selected = "T1")
        ),
        
        column(7,
               numericInput("num_obs", label = "Number of Observations", value = 5))
      ),
      
      fluidRow(
        # Select Region
        column(6,
               checkboxGroupInput("region", label = "Region", choices = unique(ncaa$Region),
                                  selected = unique(ncaa$Region))
        ),
        # select Round
        column(6,
               checkboxGroupInput("round", label = "Round", choices = unique(ncaa$Round),
                                  selected = unique(ncaa$Round))
        )
      )
      
    ),
    
    mainPanel(
      tableOutput("summarize_data"),
      plotOutput("plot")
    )
    
  )
)

# Define server logic ----
server <- function(input, output) {
  
  filter_tb <-  reactive({
    team <- if (input$team_choice == "T1") input$team1 else input$team2
    tb <- ncaa %>% mutate(Year = year(mdy(Date))) %>%
      filter(Winner == team | Loser == team) %>%
      filter(Year >= input$years[1] & Year <= input$years[2]) %>%
      filter(Region %in% input$region) %>%
      filter(Round %in% input$round)
    return(tb[1:min(dim(tb)[1], input$num_obs),])
  })
  
  plot <- reactive({
    team <- if (input$team_choice == "T1") input$team1 else input$team2
    # rearrange so the opening round comes first in Roundlevel
    RoundLevel = c(unique(ncaa$Round)[7], unique(ncaa$Round)[1:6])
    data <- ncaa %>% mutate(Year = year(mdy(Date))) %>%
      mutate(Round = factor(Round, levels = RoundLevel, ordered=T)) %>%
      filter(Winner == team | Loser == team) %>%
      filter(Year >= input$years[1] & Year <= input$years[2]) %>%
      mutate(champion = Round == "National Championship" & Winner == team) %>%
      group_by(Year) %>% summarize(max.round = max(Round),
                                   champ = ifelse(as.logical(max(champion)), "Won Championship", NA))
    plot <- data %>% ggplot(aes(x=Year, y=max.round, fill=champ)) + geom_col(orientation="x") +
      scale_y_discrete(drop=F) +
      labs(x="Year", y="Furthest round reached", title=paste("March Madness results: ", team),
           fill="") + theme_classic() + scale_fill_manual(values = "#ee3333", limits = "Won Championship")
    return(plot)
  })
  
  output$summarize_data <- renderTable(filter_tb())
  output$plot <- renderPlot(plot())
}

# Run the app ----
shinyApp(ui = ui, server = server)