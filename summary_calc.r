# This Doc for calculating summary info
library(dplyr)

# Making dfs and basic notes from park visits data
park_visits <- read.csv("park_visits.csv")
park_visits <- park_visits %>% filter(ParkType == "National Park") %>% mutate(visitors_millions = (10^logVisits)/1000000)
by_park_year <- park_visits %>% group_by(ParkName, Year) %>% summarise(total_vis = sum(visitors_millions))
vis_by_region <- park_visits %>% group_by(Region) %>% summarise(total_vis = sum(visitors_millions))
vis_by_state <- park_visits %>% group_by(State) %>% summarise(total_vis = sum(visitors_millions))

most_vis_state <- (filter(vis_by_state, total_vis == max(vis_by_state$total_vis)))$State
least_vis_state <- (filter(vis_by_state, total_vis == min(vis_by_state$total_vis)))$State

most_vis_region <- (filter(vis_by_region, total_vis == max(vis_by_region$total_vis)))$Region
least_vis_region <- (filter(vis_by_region, total_vis == min(vis_by_region$total_vis)))$Region

most_vis_park <- filter(by_park_year, total_vis == max(by_park_year$total_vis)) %>% select(ParkName, Year)
mv_park_year <- paste0(most_vis_park$ParkName, ", ", most_vis_park$Year)

least_vis_park <- filter(by_park_year, total_vis == min(by_park_year$total_vis)) %>% select(ParkName, Year)
lv_park_year <- paste0(least_vis_park$ParkName, ", ", least_vis_park$Year)

# Making dfs with parks data
parks <- read.csv("parks.csv")

