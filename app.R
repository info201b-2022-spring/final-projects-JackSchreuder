# App Document
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
source("summary_calc.r")

filtered_df <- vis_region_year

ui <- fluidPage(
  titlePanel("Assesment of National Parks' Environmental Impact"),
  tabsetPanel(type="tabs",
              tabPanel(title = "Introduction",
                       h2("Introduction to Our National Parks Analysis"),
                       h4("Jack Schreuder and Rudy Nguyen"),
                       p("Example Paragraph that contains useful words and such")),
              tabPanel(title = "Exploratory Chart 1",
                       h2("Explore the relationship between park acreage and visitation:"),
                       plotlyOutput("exch1"),
                       ),
              tabPanel("Exploratory Chart 2"),
              tabPanel(title = "Exploratory Chart 3",
                       h2("Explore regional visitation trends over time"),
                       sidebarPanel(
                         checkboxGroupInput(inputId = "regions",
                                       label = h5("Choose which regions to include:"),
                                       choices = vis_by_region$Region)
                       ),
                       mainPanel(
                         plotOutput("exch3")
                       )),
              tabPanel("Summary and Conclusion"))
)

server <- function(input, output) {
  output$exch1 <- renderPlotly({
    ch1 <- plot_ly(vis_to_acre, x = ~Acres, y = ~total_vis, type = 'scatter', mode = 'markers',
                   text = ~paste(ParkName, "<br>Visitor/Acreage ratio: ", (round(vis_acre_ratio, digits = 5)), State))
    ch1 <- ch1 %>%
      add_trace(
        marker = list(color='green', size = ~vis_acre_ratio, sizeref = 4, sizemode = 'area'),
        showlegend = F
      )
  })

  output$exch3 <- renderPlot({
    filtered_df <- vis_region_year %>% filter(Region %in% input$regions)
    ggplot(filtered_df, aes(x=Year, y=total_vis, color=Region))+
      geom_line()
  })
}

shinyApp(ui = ui, server = server)