library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)
# source("chart_2.r")


#--------------------------------- server --------------------------------------
server <- function(input, output) {
  output$intro <- renderText({
    return("This report studies the visitation of the United States National 
            Parks Service. We break down based on state and region to determine 
            which state makes the best use of their national park(s). We 
            include data about the size of each park to compare if larger parks 
            get more visitors, and also to see what the ratio of park size to 
            visitors is (ie which park earns the most bang for its buck). Parks 
            that are smaller and have higher visitation are more efficient and 
            garner more business for the NPS. These parks however are not to be 
            exalted in comparison to those with a very low visitor to area ratio 
            (meaning there are many fewer visitors per acre of land). We claim 
            that the parks with the lowest ratio of visitors to area are the 
            most successful at maintaining and untouched landscape. These parks 
            take large areas and keep them the most clear of human presence.")
  })
  
  output$concl <- renderText({
    return("conclusion")
  })
  
  output$chart1 <- renderPlotly({
    # put chart_1.r contents here
  })

  output$chart1_text <- renderText({
    return("include summary of chart 1 here")
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
  
  output$chart2_text <- renderText({
    return("include summary of chart 2 here")
  })
  
  output$chart3 <- renderPlotly({
    # put chart_3.r contents here
  })
  
  output$chart3_text <- renderText({
    return("include summary of chart 3 here")
  })
}