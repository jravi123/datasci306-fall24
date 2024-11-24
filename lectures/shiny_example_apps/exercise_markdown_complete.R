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
      req(input$domain)
      
      if (input$domain == "All") {
        header <- "All links"
        tbl <- links
      } else {
        # regex pattern: ".domain$" to match end of string only
        header <- paste(input$domain, "links")
        tbl <- filter(links, str_detect(url, paste0(input$domain, "$")))
      }
      
      md <- paste0("* [", tbl$title, "](", tbl$url, ")")
      markdown(c(paste("##", header), md))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
