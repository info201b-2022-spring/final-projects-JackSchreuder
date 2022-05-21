# This doc for the second chart

library(ggplot2)
library(dplyr)
library(viridis)
library(hrbrthemes)
library(usmap)

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
  filter(Year == "2016", ParkType == "National Park") %>% 
  group_by(State) %>% 
  summarise(total_visitor = sum(logVisits))

colnames(total_visitor_state)[1] <- "state"

chart_2_df <- merge(
  x=total_visitor_state,
  y=us_states_territories,
  by="state"
)

chart_2_df <- chart_2_df %>%
  mutate(values = total_visitor/as.numeric(Population..2019.))

chart_2 <- plot_usmap(data = chart_2_df, regions = "states") +
  scale_fill_continuous(
    low = "light yellow", high = "dark red", 
    name = "NP visitors to population ratio", 
    label = scales::comma) +
  labs(title = "U.S. States",
       subtitle = "Ratio of Visitors to Population by State") +
  theme(legend.position = "right")

print(chart_2)

