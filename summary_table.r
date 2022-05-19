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