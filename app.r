# App Document
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyverse)
source("summary_calc.r")
source("chart_2.r")

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
              tabPanel("Exploratory Chart 2",
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
                       )),
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
              tabPanel(title = "Summary and Conclusion",
                       h2("Conclusion and Analysis"),
                       h4("What we learned from chart 1:"),
                       p("The first thing we should note about chart 1 is that there is a ton of diversity in all
                         the national parks in the USA. There are some that are really big that nobody goes to, there
                         are some small that no one goes to, and there are just the opposite. In this project, we argued that
                         parks with a low visitor to acreage ratio were the best in conserving land. On this chart, those are
                         the points that are very small. Further, the points on the far right side of the graph best accomplish
                         this, since they have the largest area, and thus conserve the largest amount of land."),
                       h4("What we learned from chart 2:"),
                       p("Things we learned..."),
                       h4("What we learned from chart 3:"),
                       p("Chart 3 is important because it shows that national park visitation is trending upward, which means
                         more people are getting to see the beautiful parts of the country. This is generally a good thing for
                         the NPS, since more people = more revenue. In terms of land conservation, this may not be a great thing.
                         Especially given the large gap between the Intermountain and Southeast regions and the rest of the
                         country. This means that the parks in those places are experiencing high volume visitors, and their land
                         is likely being eroded quicker than in the Alaska region. Therefore, it can be argued that the regions
                         with the flatest lines (ie the least change in visitation) are the most effective NPS regions."),
                       h4("Overall:"),
                       p("The National Parks Service is a very well run organization that achieves a great mix of making empty
                         land available for the general public to enjoy and keeping large swaths of land free of development.
                         In the end, we conclude that the NPS has achieved both the land conservation goal it publicized
                         , but also the more subtle goal of making sure people got more in touch with their primal nature.")
                       ))
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
  
  output$chart2 <- renderPlotly({
    parks <- read.csv("parks.csv")
    us_states_territories <- read.csv("us-states-territories.csv")
    park_visits <- read.csv("park_visits.csv")
    
    us_states_territories <- us_states_territories %>% 
      filter(Type == "State") %>% 
      select(Abbreviation, Population..2019.)
    
    colnames(
      us_states_territories)[
        which(names(us_states_territories) == "Abbreviation")] <- "state"
    
    us_states_territories$state <- str_sub(us_states_territories$state, end=2)
    us_states_territories$Population..2019. <- 
      str_replace_all(us_states_territories$Population..2019., ',', '')
    
    total_visitor_state <- park_visits %>%
      filter(Year == "2014", ParkType == "National Park") %>% 
      group_by(State) %>%
      summarise(total_visitor_2016 = sum(logVisits, na.rm = TRUE))
    
    
    colnames(total_visitor_state)[1] <- "state"
    
    chart_2_df <- merge(
      x=total_visitor_state,
      y=us_states_territories,
      by="state"
    )
    
    if (input$value == "total_visitor_2016") {
      chart_2_df <- chart_2_df %>% 
        mutate(values = total_visitor_2016)
      scale_name = "Visitors (persons)"
    } else {
      chart_2_df <- chart_2_df %>% 
        mutate(values = as.numeric(Population..2019.))
      scale_name = "Population (persons)"
    }
    
    chart_2 <- plot_usmap(data = chart_2_df, regions = "states") +
      scale_fill_continuous(
        low = "light yellow", high = "dark red",
        name = scale_name,
        label = scales::comma) +
      labs(title = "U.S. States") +
      theme(legend.position = "right")
    ggplotly(chart_2)
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