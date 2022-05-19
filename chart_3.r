# this doc for the third chart
library(ggplot2)
library(dplyr)

park_visits <- read.csv("park_visits.csv")
chart3_df <- park_visits %>% group_by(Year) %>% summarise(total_log_vis = sum(logVisits))

chart_3 <- ggplot(data = chart3_df, aes(x=Year, y=total_log_vis)) +
  geom_line(color="blue") +
  geom_point() +
  ggtitle("Park Visitation 2010-2016") +
  xlab("Year") +
  ylab("Visitors (log)")

print(chart_3)