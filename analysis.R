library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

data <- read.csv("air_visual_data.csv")
data <- data %>% 
  select(-X)
