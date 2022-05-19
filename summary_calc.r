# This Doc for calculating summary info
library(dplyr)
library(stringr)

# Making dfs and basic notes from park visits data
# be sure to set your working directory to where ever the csvs are stored on your machine
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
parks$Park.Name <- str_to_title(parks$Park.Name)
parks$Park.Name <- str_replace(parks$Park.Name, "National Park", "NP")
parks$Park.Name <- str_replace(parks$Park.Name, "And Preserve", "& PRES")
parks$Park.Name <- str_replace(parks$Park.Name, " - St", "-St.")
state_np_area <- parks %>% group_by(State) %>% summarise(total_area = sum(Acres))
largest_park <- (filter(parks, Acres == max(parks$Acres))) %>% select(Park.Name, State)
largest_park <- paste0(largest_park$Park.Name, ", ", largest_park$State)

smallest_park <- filter(parks, Acres == min(parks$Acres)) %>% select(Park.Name, State)
smallest_park <- paste0(smallest_park$Park.Name, ", ", smallest_park$State)

joint_park_df <- merge(x=park_visits, y=parks, by.x = "ParkName", by.y = "Park.Name")
joint_park_df <- select(joint_park_df, ParkName, ParkType, Region, State.x, Year, Month, logVisits, visitors_millions, Acres)

total_vis_per_park <- by_park_year %>% group_by(ParkName) %>% summarise(total_vis = sum(total_vis))
total_vis_per_park$ParkName <- str_to_title(total_vis_per_park$ParkName)
total_vis_per_park$ParkName <- str_replace(total_vis_per_park$ParkName, "Np", "NP")
total_vis_per_park$ParkName <- str_replace(total_vis_per_park$ParkName, "Pres", "PRES")
vis_to_acre <- merge(x=total_vis_per_park, y=parks, by.x = "ParkName", by.y = "Park.Name")
vis_to_acre <- select(vis_to_acre, -c(Park.Code, Latitude, Longitude))
vis_to_acre <- mutate(vis_to_acre, vis_acre_ratio = total_vis / Acres)
most_vis_per_acre <- (filter(vis_to_acre, vis_acre_ratio == max(vis_to_acre$vis_acre_ratio))) %>%
  select(ParkName, vis_acre_ratio)
most_vis_per_acre <- paste0(most_vis_per_acre$ParkName, ", ", most_vis_per_acre$vis_acre_ratio, " million visitors per acre")

least_vis_per_acre <- (filter(vis_to_acre, vis_acre_ratio == min(vis_to_acre$vis_acre_ratio))) %>%
  select(ParkName, vis_acre_ratio)
least_vis_per_acre <- paste0(least_vis_per_acre$ParkName, ", ", least_vis_per_acre$vis_acre_ratio, " million visitors per acre")

num_parks <- nrow(parks)

# Summary info list
summary_info <- list()
summary_info$num_parks <- num_parks
summary_info$largest_park <- largest_park
summary_info$smallest_park <- smallest_park
summary_info$most_visited_state <- most_vis_state
summary_info$least_visited_state <- least_vis_state
summary_info$most_visited_region <- most_vis_region
summary_info$least_visited_region <- least_vis_region
summary_info$most_visited_park_for_year <- mv_park_year
summary_info$least_visited_park_for_year <- lv_park_year
summary_info$highest_vis_per_acre <- most_vis_per_acre
summary_info$lowest_vis_per_acre <- least_vis_per_acre

