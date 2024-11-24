library(shiny)

library(tidyverse)
library(stringr)

links <- tibble(title = c("Google", 
                          "UMich", 
                          "Wikipedia", 
                          "CRAN",
                          "Apple",
                          "UIUC",
                          "Morgan Stanley"),
                url = paste0("https://", c("google.com", 
                                          "umich.edu", 
                                          "wikipedia.org", 
                                          "cran.r-project.org",
                                          "apple.com",
                                          "uiuc.edu",
                                          "morganstanley.com")))

ui <- fluidPage(

    # Application title
    titlePanel("Link Directory"),

    sidebarLayout(
        sidebarPanel(
          selectInput("domain", "Select a domain type", 
                      choices = c("All", ".org", ".edu", ".com"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
          htmlOutput("links")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$links <- renderUI({
      ## use `input$domain` and a regex to find the rows of the `links` table to display
      ## use the `markdown` function to display this as a bulleted list of links
      ## [Link Text](http://link.com)
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
