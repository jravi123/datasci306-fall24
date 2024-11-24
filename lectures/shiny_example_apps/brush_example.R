library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("plot", brush = "plot_brush"),
  verbatimTextOutput("data")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderPrint({
    mean_x <- 0
    mean_y <- 0
    cat("The mean of x is", mean_x, ", the mean of y is", mean_y)
  })
  
}


shinyApp(ui = ui, server = server)