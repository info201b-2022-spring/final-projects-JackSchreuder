# App Document
library(shiny)
library(dplyr)
library(ggplot2)
source("summary_calc.r")


ui <- fluidPage(
  titlePanel("Assesment of National Parks' Environmental Impact"),
  tabsetPanel(type="tabs",
              tabPanel(title = "Introduction",
                       h2("Introduction to Our National Parks Analysis"),
                       h4("Jack Schreuder and Rudy Nguyen"),
                       p("Example Paragraph that contains useful words and such")),
              tabPanel(title = "Exploratory Chart 1",
                       h2("Explore the relationship between park acreage and visitation:"),
                       plotOutput("exch1", click = "ch1_click"),
                       tableOutput("ch1_info")
                       ),
              tabPanel("Exploratory Chart 2"),
              tabPanel("Exploratory Chart 3"),
              tabPanel("Summary and Conclusion"))
)

server <- function(input, output) {
  output$exch1 <- renderPlot({
    ggplot(vis_to_acre, aes(x=Acres, y=total_vis))+
      geom_point()
  })
  output$ch1_info <- renderTable({
    nearPoints(vis_to_acre, input$ch1_click, xvar = "Acres", yvar = "total_vis")
  })
}

shinyApp(ui = ui, server = server)