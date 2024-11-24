library(shiny)
library(ggplot2)
library(tidyverse)

validVars <- select(mpg, where(is.numeric)) |> colnames()
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("MPG Data Variable Selection"),

    sidebarLayout(
        sidebarPanel(
          radioButtons("radio_x", "Choose variable for X-axis", choices = validVars, selected = "cty"),
          radioButtons("radio_y", "Choose variable for Y-axis", choices = validVars, selected = "hwy"),
        ),

        mainPanel(
           plotOutput("mpgPlot")
        )
    )
)

server <- function(input, output) {

    output$mpgPlot <- renderPlot({
      set.seed(3030583) # make jitter the same every time
      ## update this to use the radio box selections for X and Y
      req(input$radio_x, input$radio_y)
      if(input$radio_x == input$radio_y) {
        ggplot(mpg, aes_string(x = input$radio_x)) + geom_density()
      } else {
        ggplot(mpg, aes_string(x = input$radio_x, y = input$radio_y)) + geom_jitter()
      }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
