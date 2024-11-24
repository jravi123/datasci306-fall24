library(shiny)
library(ggplot2)

ui <- fluidPage(
  plotOutput("plot", brush = "plot_brush"),
  tableOutput("data")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    req(input$plot_brush)
    brushedPoints(mtcars, input$plot_brush)
  })

}


shinyApp(ui = ui, server = server)