# server for shiny app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
source("analysis.R")
View(values)
my_server <- function(input, output) {
  output$data_table <- renderDT({
    values
  })
  
  output$plot_one <- renderPlot({
    
  })
}

shinyServer(my_server)
