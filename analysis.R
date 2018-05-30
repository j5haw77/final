
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

data <- read.csv("air_visual_data.csv")
data <- data %>% 
  select(-X)
colnames(data) <- c("City", "Humidity(%)", "Weather Icon Code", "Atm Pressure(hPa)", 
                    "Temperature(°C)", "Wind Direction(°)", "Wind Speed(mph)", 
                    "AQI (US EPA)", "Main Pollutant (US)", "AQI (CN MEP)", 
                    "Main Pollutant (CN)", "Latitude", "Longitude")

# Add pre-defined theme to the given plot
add_theme <- function(plot) {
  plot +
    theme(
      plot.title = element_text(color="red", 
                                size=20, 
                                face="bold.italic", 
                                hjust=0.5
      ),
      plot.margin = margin(t=20, r=40, b=20, l=40),
      axis.title.x = element_text(size=16, face="bold", color="blue"),
      axis.title.y = element_text(size=16, face="bold", color="blue", margin = margin(r=10)),
      axis.text.x = element_text(angle=90, size=12)
    )
}

