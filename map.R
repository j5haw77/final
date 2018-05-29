library("ggplot2")
library("dplyr")
library("hexbin")
library("tidyr")
library("plotly")
library("ggmap")
library("grid")

map_with_values <- read.csv("air_visual_data.csv")
source("analysis.R")

states <- map_data("state")
states <- filter(states,region=="washington",subregion=="main")
states <- states %>% rename(Latitude=lat)
states <- states %>% rename(Longitude=long)
map_with_values  <- rename(map_with_values , Pressure="ATM.Pressure")
map_with_values  <- rename(map_with_values , Temperature="Temperature")
map_with_values  <- rename(map_with_values , Pollution="AQI.CN.MEP.")

map <- ggplot(data = states) +
  geom_polygon(mapping = aes(x = Longitude, y = Latitude), 
               na.rm = TRUE, fill = "white", color = "black") +
  ggtitle("Top 20 most populated cities in Washington") +
  geom_point(data = map_with_values, 
             aes(x = Longitude, 
                 y = Latitude, 
                 fill = Pollution, 
                 size = Temperature
                ), 
             color = "black", 
             shape=21, 
             stroke = 1,
             na.rm = TRUE
            )+
  scale_fill_gradient(name = "Pollution in AQI rating", low = "white", high = "red") +
  scale_size(name = "Temperature in C") +
  coord_quickmap()

map <- add_theme(map)