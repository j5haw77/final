# server for shiny app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")
source("map.R")

my_server <- function(input, output) {
  reactive_vars <- reactiveValues()
  
  selected_df <- reactive({
    data %>% select(City, input$select, Latitude, Longitude)
  })
  
  observeEvent(input$plot_click, {
    selected <- nearPoints(selected_df(), 
                           input$plot_click, 
                           xvar = "City", 
                           yvar = input$select)
    colnames(selected) <- c("City", input$select, "Latitude", "Longitude")
    reactive_vars$selected_value <- selected
  })
  
  output$chosen_value <- renderTable({
    reactive_vars$selected_value
  })
  
  output$data_table <- renderDT({
    if (!is.null(input$categories)) {
      data %>% select(City, input$categories, Latitude, Longitude)
    } 
  })
  
  output$pollut_plot <- renderPlot({
    plot <- selected_df() %>% 
      ggplot(mapping = aes(x = City, 
                           y = data[input$select], 
                           color = (City %in% reactive_vars$selected_value)), 
             na.rm = TRUE
          ) +
      geom_point(stat = "identity", size = 4) +
      guides(color = FALSE) +
      labs(title = paste0(input$select, " by States"),
           x = "Cities",
           y = input$select
      )
    add_theme(plot)
    
  })
  
  output$map_plot <- renderPlot({
    map
  })
}

shinyServer(my_server)
