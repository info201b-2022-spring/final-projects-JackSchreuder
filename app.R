# App Document
library(shiny)
library(dplyr)


ui <- fluidPage(
  titlePanel("Assesment of National Parks' Environmental Impact"),
  tabsetPanel(type="tabs",
              tabPanel("Introduction"),
              tabPanel("Exploratory Chart 1"),
              tabPanel("Exploratory Chart 2"),
              tabPanel("Exploratory Chart 3"),
              tabPanel("Summary and Conclusion"))
)

server <- function(input, output) {
  # content
}

shinyApp(ui = ui, server = server)