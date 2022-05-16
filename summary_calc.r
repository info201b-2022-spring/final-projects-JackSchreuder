# This Doc for calculating summary info
library(dplyr)

park_visits <- read.csv("park_visits.csv")
park_visits <- park_visits %>% mutate(visitors_millions = (10^logVisits)/1000000)
by_park_year <- park_visits %>% group_by(ParkName, Year) %>% summarise(total_vis = sum(visitors_millions))
vis_by_region <- park_visits %>% group_by(Region) %>% summarise(total_vis = sum(visitors_millions))
