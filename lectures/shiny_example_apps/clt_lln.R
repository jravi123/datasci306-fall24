ui <- fluidPage(
  titlePanel("Central limit theorem and the Law of Large Numbers"),
  fluidRow(column(6,
                  mainPanel(plotOutput("hist_mean"))),
           column(6,
                  mainPanel(plotOutput("hist_sd")))),
  fluidRow(
    column(12,
      sidebarPanel(
        numericInput("m", "Number of samples:", 2, min = 1, max = 100)
      )
    )
  )
)
server <- function(input, output, session) {
  output$hist_mean <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20, xlim = c(0,1))
  }, res = 96)
  output$hist_sd <- renderPlot({
    sds <- replicate(1e4, sd(runif(input$m)))
    hist(sds, breaks = 20, xlim = c(0, 1))
  }, res = 96)
}

shinyApp(ui = ui, server = server)
