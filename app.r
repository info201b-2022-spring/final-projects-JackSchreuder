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
                       p("This report will explore the effectiveness of the US National Parks Service.
                         There are two modes in which a National Park can be successful. 1. They reciece a high number
                         of visitors. 2. They conserve a large amount of land."),
                       p("The National Parks were initially created as a part of the mythic frontier in a national panic
                         about men growing soft and out of touch with primal nature. To solve this, Teddy Roosevelt, joined
                         by environmentalists and transcendentalists begun a campaign to preserve the most epic pieces of
                         untouched land in the country. The result was places like Yosemite, Yellowstone, Mount Rainier, etc.
                         The question is: Which was most effective, preserving land, or providing a place to make sure there
                         weren't any more soft men? Our report will use data to explore data and trends to gain insight into
                         the answers of these questions.")
                       ),
              tabPanel(title = "Exploratory Chart 1",
                       h2("Explore the relationship between park acreage and visitation:"),
                       h4("2010-16 Park Visitation (millions) vs Park area (acres)"),
                       h6("Size of each point corresponds to the visitor / acres ratio"),
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
      geom_line()+
      labs(title = "Visitation by Region 2010-16",
           x = "Time (Years)",
           y = "Visitors (Millions)")
  })
}

shinyApp(ui = ui, server = server)