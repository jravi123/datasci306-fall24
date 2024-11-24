library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("MPG Data Set Zoom"),

    sidebarLayout(
        sidebarPanel(
            ## add four inputs for the minimum and maximum x and y values
            ## make sure to use checking so that users can't exceed these values
        ),

        mainPanel(
           plotOutput("mpgPlot")
        )
    )
)

server <- function(input, output) {

    output$mpgPlot <- renderPlot({
      ## update this to use input$min_x, input$max_x, etc after updating the UI
      ggplot(mpg, aes(cty, hwy)) + geom_jitter() +
        xlim(min(mpg$cty),
             max(mpg$cty)) +
        ylim(min(mpg$hwy),
             max(mpg$hwy))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
