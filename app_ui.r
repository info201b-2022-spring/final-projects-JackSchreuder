library(shiny)
library(plotly)

intro_page <- tabPanel(
  "Introduction",
  titlePanel("National Parks in the United States"),
  textOutput("intro")
)

chart1 <- tabPanel(
  "Data plot 1"
)

chart2 <- tabPanel(
  "Data plot 2",
  sidebarLayout(
    sidebarPanel(
      h5("Controls"),
      selectInput(
        inputId = "value",
        label = "View state population or national park visitors",
        choices = list("Total NP visitors in 2016" = "total_visitor_2016", 
                       "State population in 2019" = "Population..2019."),
        multiple = FALSE,
        width = '50%',
      )
    ),
    mainPanel(
      plotlyOutput("chart2"),
      textOutput("chart2_text")
    )
  )
)

chart3 <- tabPanel(
  "Data plot 3"
)

conclusion_page <- tabPanel(
  "Conclusion",
  textOutput("outro")
)

ui <- navbarPage(
  "National Parks",
  intro_page,
  chart1,
  chart2,
  chart3,
  conclusion_page
)