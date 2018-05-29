library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

data <- read.csv("air_visual_data.csv")
data <- data %>% 
  select(-X)
colnames(data) <- c("City", "Humidity", "Weather Icon Code", "Atm Pressure", 
                    "Temperature", "Wind Direction", "Wind Speed", 
                    "AQI(US EPA)", "Main Pollutant(US)", "AQI(CN MEP)", 
                    "Main Pollutant(CN)", "Latitude", "Longitude")
