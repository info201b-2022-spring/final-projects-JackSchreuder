# This doc for the second chart

library(ggplot2)
library(dplyr)

us_states_territories <- read.csv("us-states-territories.csv")

us_states_territories <- us_states_territories %>% 
  filter(Type == "State") %>% 
  select(Abbreviation, Population..2019., area..square.miles.)

visitors <- park_visits_chart %>%
  filter(Year == "2016") %>% 
  mutate(
    time = paste(Month, ", ", Year, sep = "")
  ) %>% 
  select(State, time, Region, ParkName, visitors)

visit_to_pop <- merge(
  x=visitors,
  y=us_states_territories,
  by.x="State",
  by.y="Abbreviation",
  all=TRUE
)