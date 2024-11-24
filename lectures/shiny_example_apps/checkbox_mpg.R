library(shiny)
library(ggplot2)

tmp <- unique(mpg$manufacturer)
manufacs <- tmp 
names(manufacs) <- stringr::str_to_title(manufacs)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("MPG Plotting Options"),

    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("groups", "Which manufacturer(s)?",
                             choices = manufacs,
                             selected = manufacs)
        ),

        mainPanel(
           plotOutput("mpgPlot")
        )
    )
)

server <- function(input, output) {

    output$mpgPlot <- renderPlot({
      set.seed(3030583) # make jitter the same every time
      req(input$groups)
      ## update this to use input$min_x, input$max_x, etc after updating the UI
      filter(mpg, manufacturer %in% input$groups) %>%
       ggplot(aes(cty, hwy, color = manufacturer)) + geom_jitter() +
        xlim(min(mpg$cty), max(mpg$cty)) +
        ylim(min(mpg$hwy), max(mpg$hwy))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
