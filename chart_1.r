# This doc for the first chart
library(ggplot2)
library(dplyr)
library(forcats)

# Make sure to run summary calc first
chart1_df <- vis_to_acre %>% group_by(State) %>% summarise(statewide_ratio = (sum(total_vis)/sum(Acres)))

median_swr <- median(chart1_df$statewide_ratio)

chart1_df <- chart1_df %>%
  filter(statewide_ratio >= median_swr) %>%
  mutate(State = fct_reorder(State, statewide_ratio))

chart1 <- ggplot(chart1_df, aes(x=State, y=statewide_ratio))+
  geom_bar(stat="identity")+
  theme(axis.text.x = element_text(angle = -20))

print(chart1)