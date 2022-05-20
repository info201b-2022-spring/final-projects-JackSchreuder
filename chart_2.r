# This doc for the second chart

library(ggplot2)
library(dplyr)
library(viridis)
library(hrbrthemes)

us_states_territories <- read.csv("us-states-territories.csv")
park_visits <- read.csv("park_visits.csv")

us_states_territories <- us_states_territories %>% 
  filter(Type == "State") %>% 
  select(Abbreviation, Population..2019., area..square.miles.)

colnames(
  us_states_territories)[
    which(names(us_states_territories) == "Abbreviation")] <- "State"

mean_visitor <- park_visits %>%
  filter(Year == "2016", ParkType == "National Park") %>% 
  group_by(ParkName, State) %>% 
  summarise(mean_visitors = mean(logVisits), .groups = 'drop') %>% 
  group_by(State) %>% 
  summarise(total_mean_visitors = sum(mean_visitors))

chart_2_df <- merge(
  x=mean_visitor,
  y=us_states_territories,
  by="State"
)

chart_2 <- ggplot(
  data = mean_visitor, 
  aes(x=State, y=total_mean_visitors)) + 
  geom_area(alpha=0.6 , size=.5, colour="white") +
  scale_fill_viridis(discrete = T) +
  theme_ipsum() + 
  ggtitle("mean")

print(chart_2)