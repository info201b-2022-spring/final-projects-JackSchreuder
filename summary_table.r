# This doc for making a table of summary info
parks <- read.csv("parks.csv")
parks$Park.Name <- str_to_title(parks$Park.Name)
parks$Park.Name <- str_replace(parks$Park.Name, "National Park", "NP")
parks$Park.Name <- str_replace(parks$Park.Name, "And Preserve", "& PRES")
parks$Park.Name <- str_replace(parks$Park.Name, " - St", "-St.")
state_np_area <- parks %>% group_by(State) %>% summarise(total_area = sum(Acres))

# state_np_area shows the total area in acres of NPS land in each state
print(state_np_area)

park_visits <- read.csv("park_visits.csv")
park_visits <- park_visits %>% filter(ParkType == "National Park") %>% mutate(visitors_millions = (10^logVisits)/1000000)
by_park_year <- park_visits %>% group_by(ParkName, Year) %>% summarise(total_vis = sum(visitors_millions))
vis_by_region <- park_visits %>% group_by(Region) %>% summarise(total_vis = sum(visitors_millions))
vis_by_state <- park_visits %>% group_by(State) %>% summarise(total_vis = sum(visitors_millions))

# vis_by_state shows how many millions of visitors visited any national park in a state over the time period
print(vis_by_state)

total_vis_per_park <- by_park_year %>% group_by(ParkName) %>% summarise(total_vis = sum(total_vis))
total_vis_per_park$ParkName <- str_to_title(total_vis_per_park$ParkName)
total_vis_per_park$ParkName <- str_replace(total_vis_per_park$ParkName, "Np", "NP")
total_vis_per_park$ParkName <- str_replace(total_vis_per_park$ParkName, "Pres", "PRES")
vis_to_acre <- merge(x=total_vis_per_park, y=parks, by.x = "ParkName", by.y = "Park.Name")
vis_to_acre <- select(vis_to_acre, -c(Park.Code, Latitude, Longitude))
vis_to_acre <- mutate(vis_to_acre, vis_acre_ratio = total_vis / Acres)

# vis to acre shows the ratio of millions of visitors to land area of the parks.
print(vis_to_acre)