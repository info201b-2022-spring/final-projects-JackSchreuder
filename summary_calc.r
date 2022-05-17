# This Doc for calculating summary info
library(dplyr)
library(stringr)

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
parks$Park.Name <- str_replace(parks$Park.Name, "National Park", "NP")
state_np_area <- parks %>% group_by(State) %>% summarise(total_area = sum(Acres))
largest_park <- (filter(parks, Acres == max(parks$Acres))) %>% select(Park.Name, State)
largest_park <- paste0(largest_park$Park.Name, ", ", largest_park$State)

smallest_park <- filter(parks, Acres == min(parks$Acres)) %>% select(Park.Name, State)
smallest_park <- paste0(smallest_park$Park.Name, ", ", smallest_park$State)

joint_park_df <- merge(x=park_visits, y=parks, by.x = "ParkName", by.y = "Park.Name")
joint_park_df <- select(joint_park_df, ParkName, ParkType, Region, State.x, Year, Month, logVisits, visitors_millions, Acres)
