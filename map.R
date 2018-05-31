map_with_values <- read.csv("air_visual_data.csv")

states <- map_data("state")
states <- filter(states,region=="washington",subregion=="main")
counties <- map_data("county")
states  <- subset(counties, region == "washington")
states <- states %>% rename(Latitude=lat)
states <- states %>% rename(Longitude=long)
map_with_values  <- rename(map_with_values , Pressure="ATM.Pressure")
map_with_values  <- rename(map_with_values , Temperature="Temperature")
map_with_values  <- rename(map_with_values , Pollution="AQI.CN.MEP.")

map <- ggplot(data = states) +
  geom_polygon(mapping = aes(x = Longitude, y = Latitude,group=group), 
               na.rm = TRUE, fill = "white", color = "black") +
  ggtitle("Top 40 most populated cities in Washington") +
  geom_point(data = map_with_values, 
             aes(x = Longitude, 
                 y = Latitude, 
                 fill = Pollution, 
                 size = Population
             ), 
             color = "black", 
             shape=21, 
             stroke = 1,
             na.rm = TRUE
  )+
  coord_fixed()+
  scale_fill_gradient(name = "Pollution in AQI rating", 
                      low = "white", 
                      high = "red"
  ) +
  scale_size(name = "Population") +
  
  coord_quickmap()

map <- add_theme(map)