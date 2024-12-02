library(shinydashboard)
library(dplyr)
library(ggplot2)
library(forcats)
library(tidyverse)
library(shiny)

if (!exists("injuries")) {
  injuries <- read_tsv("data/injuries.tsv.gz")
  products <- read_tsv("data/products.tsv")
  population <- read_tsv("data/population.tsv")
}

#<< ui
prod_codes <- setNames(products$prod_code, products$title)

ui <- dashboardPage(
 dashboardHeader(title="Dashboard"),
 dashboardSidebar(
 fluidRow(
     column(12,
       selectInput("code", "Product", choices = prod_codes)
     )
   )),
 dashboardBody(
 fluidRow(
     column(12, plotOutput("age_sex"))
   ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  )
 )
)

#<< server
server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))

  output$diag <- renderTable(
    selected() |> count(diag, wt = weight, sort = TRUE)
  )
  output$body_part <- renderTable(
    selected() |> count(body_part, wt = weight, sort = TRUE)
  )
  output$location <- renderTable(
    selected() |> count(location, wt = weight, sort = TRUE)
  )

  df_summary <- reactive({
    selected() |>
      count(age, sex, wt = weight) |>
      left_join(population, by = c("age", "sex")) |>
      mutate(rate = n / population * 1e4)
  })

  output$age_sex <- renderPlot({
    df_summary() |>
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  }, res = 96) # res is resolution of plot in pixels per inch
}

shinyApp(ui, server)