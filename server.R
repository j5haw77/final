# server for shiny app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
source("analysis.R")

my_server <- function(input, output) {
  output$data_table <- renderDT({
    data %>% select(city, Humidity, ATM.Pressure, Temperature)
  })
  
  output$plot_one <- renderPlot({
    
  })
}

shinyServer(my_server)