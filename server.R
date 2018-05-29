# server for shiny app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
source("analysis.R")

my_server <- function(input, output) {
  
  output$data_table <- renderDT({
    if (!is.null(input$categories)) {
      data %>% select(City, input$categories, Latitude, Longitude)
    } 
   })
  
  output$pollute_plot <- renderPlot({
    data %>% select(City, input$categories, Latitude, Longitude) %>% 
    ggplot(aes(x='Pollution', y = data[input$select])) +
      geom_point() +
      theme_minimal()
      
  })
}

shinyServer(my_server)
