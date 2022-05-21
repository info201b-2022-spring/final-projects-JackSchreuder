# This doc for the second chart

library(ggplot2)
library(dplyr)
library(viridis)
library(hrbrthemes)

us_states_territories <- read.csv("us-states-territories.csv")
park_visits <- read.csv("park_visits.csv")

us_states_territories <- us_states_territories %>% 
  filter(Type == "State") %>% 
  select(Abbreviation, Population..2019.)

colnames(
  us_states_territories)[
    which(names(us_states_territories) == "Abbreviation")] <- "State"

us_states_territories$State <- str_sub(us_states_territories$State, end=2)
us_states_territories$Population..2019. <- 
  str_replace_all(us_states_territories$Population..2019., ',', '')

total_visitor_state <- park_visits %>%
  filter(Year == "2016", ParkType == "National Park") %>% 
  group_by(State) %>% 
  summarise(total_visitor = sum(logVisits))

chart_2_df <- merge(
  x=total_visitor_state,
  y=us_states_territories,
  by="State"
)

chart_2_df <- chart_2_df %>% 
  mutate(ratio = total_visitor/as.numeric(Population..2019.))

mean_ratio <- mean(chart_2_df$ratio)
  
chart_2 <- ggplot(chart_2_df, aes(x= State, y = ratio)) + 
  geom_bar(stat = 'identity', aes(fill = ratio>mean_ratio), position = 'dodge', col = 'transparent') + 
  theme_bw() + scale_fill_discrete(guide = 'none') + 
  labs(x = '', y = 'NAO Index')

print(chart_2)

