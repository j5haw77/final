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
  
  output$pollut_plot <- renderPlot({
    data %>% select(City, input$categories, Latitude, Longitude) %>% 
    ggplot(aes(x=City, y = data[input$select], color = data[input$select], na.rm = TRUE) +
      geom_point(stat = "identity") +
      ylab(input$select) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))
    
  })
}

shinyServer(my_server)
