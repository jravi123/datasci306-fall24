library(shiny)
library(ggplot2)
library(tidyverse)

## use this set of variables to do the plotting
validVars <- select(mpg, where(is.numeric)) |> colnames()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("MPG Data Variable Selection"),

    sidebarLayout(
        sidebarPanel(
          ## add two sets of radio buttons, one for X and Y variable to use
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
      ## bonus exercise: if they are the same, make a density plot insteas
      ggplot(mpg, aes_string("cty", "hwy")) + geom_jitter()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
