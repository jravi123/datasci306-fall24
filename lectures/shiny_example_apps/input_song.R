library(shiny)

ui <- fluidPage(
  
  # Application title
  titlePanel("Basic Input Examples"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("input_text", "What item is on the shelf?", "soda"),
      numericInput("input_num", "How many times should it repeat?", 99)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("song")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$song <- renderPrint({
    req(input$input_text, input$input_num)
    for (i in seq(input$input_num, 0)) {
      cat(i, "bottles of", input$input_text, "on the shelf\n")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
