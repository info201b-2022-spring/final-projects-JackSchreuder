# This doc for the first chart
library(ggplot2)
library(dplyr)

park_visits <- read.csv("park_visits.csv")
park_visits_chart <- park_visits %>% filter(ParkType == "National Park") %>% mutate(visitors = (10^logVisits))
vis_by_region_chart <- park_visits_chart %>% group_by(Region) %>% summarise(log_total_vis = log10(sum(visitors)))
reg_vis_plot <- ggplot(vis_by_region_chart, aes(x=Region, y=log_total_vis)) + geom_bar(stat="identity")
print(reg_vis_plot + labs(title = "Regions by visitation over 6 years", x = "US Region", y = "Visitors 2010-16 (log10)"))
