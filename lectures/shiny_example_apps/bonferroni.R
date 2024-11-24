
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Bonferroni Correction"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          actionButton("test_button", "Run a test")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           verbatimTextOutput("pvalue")
        )
    )
)

# Define server logic to display the results
server <- function(input, output) {
    tests <- reactiveVal(0)
    text <- eventReactive(input$test_button, {
      tests(tests() + 1)
      x <- rnorm(100)
      y <- rnorm(100)
      pv <- cor.test(x, y)$p.value
      paste("Tests:",tests(), "\n",
            "Pvalue:", pv, "\n",
            "Reject at the 5% level:", pv < 0.05, "\n",
            "Bonnferroni correct:", 0.05/tests(), "\n",
            "Bonferroni reject:", pv < 0.05/tests())
    })
    output$pvalue <- renderPrint({
      cat(text())
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
