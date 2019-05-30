library(tidyverse)
library(magrittr) # for %<>% 
library(lubridate)


# Read Data ---------------------------------------------------------------

# Toll Data
toll_data <- read_csv("Raw Data/NYThruway_origin_and_dest.csv", 
                      col_types = cols(Entrance = col_character(), # force read_csv to import cols as character to preserve trailing chars (e.g. Exit 48A)
                                       Exit = col_character()
                      )
) 
toll_data %<>% 
  select(date = Date, # remove unnecessary vars and rename for ease of work
         entrance = Entrance,
         exit = Exit,
         time = `Interval Beginning Time`)

toll_data %<>% 
  separate(time, c("hours", "minutes"), sep = 2) %>% 
  mutate(hours = as.numeric(floor(as.numeric(hours) + as.numeric(minutes)/60)), # translate 15 minute intervals to hourly intervals
         date = mdy(date), # format as date
         weekday = wday(date)) %>% # get day of the week for plotting later. Left as a number for easy Shiny filtering
  select(-minutes)

write_csv(toll_data, "Clean Data/clean_toll_data.csv")


# Location Data
location_data <- read_csv("Raw Data/Thruway_Interchanges_and_Exits.csv")

location_data %<>% 
  filter(str_detect(Route, "NYS Thruway") | str_detect(Route, "Berkshire Connector"), # filter for only data on the NY Thruway and Berkshire Connector
         !str_detect(Exit, "TB")) %>% # remove data for toll barriers
  select(exit_num = Exit, # remove unnecessary vars and rename for ease of work
         milepost = Milepost,
         latitude = Latitude,
         longitude = Longitude,
         exit_name = Description)

write_csv(location_data, "Clean Data/clean_location_data.csv")

# Format for Mapping ------------------------------------------------------

aggregated_toll_data <- toll_data %>% 
  gather(key = "action", # gather entrance and exit into a key/value pair to facilitate filtering in Shiny
         value = "exit_num",
         entrance, exit) 

aggregated_toll_data %<>% 
  left_join(location_data,
            by = "exit_num")

aggregated_toll_data %<>% 
  group_by(weekday, hours, exit_num, exit_name, latitude, longitude, action) %>% # exit_num and exit_name included to retain values post summarise(), does not affect row counts
  summarise(total = n()) %>% 
  ungroup() %>% 
  filter(!is.na(latitude))

write_csv(aggregated_toll_data, 
          "Clean Data/aggregated_toll_data.csv")
         
         
         