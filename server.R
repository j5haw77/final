# server for shiny app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

my_server <- function(input, output) {
  reactive_vars <- reactiveValues()
  
  selected_df <- reactive({
    data %>% select(City, "AQI (US EPA)", input$select, "Latitude", "Longitude")
  })
  
  observeEvent(input$plot_click, {
    selected <- nearPoints(selected_df(), 
                           input$plot_click, 
                           xvar = "AQI (US EPA)", 
                           yvar = input$select)
    colnames(selected) <- c("City", "AQI (US EPA)", input$select, "Latitude", "Longitude")
    reactive_vars$selected_value <- selected
    if (nrow(selected) == 0) {
      reactive_vars$selected_value <- NULL
    }
  })
  
  output$plot_city <- renderPlot({
    ggplot(data, aes(x = City, y = data[input$button])) +
      geom_bar(stat = "identity")
  })
  
  observeEvent(input$select, {
    reactive_vars$selected_value <- NULL
  })
  
  
  output$chosen_value <- renderTable({
    reactive_vars$selected_value
  })
  
  output$data_table <- renderDT({
    if (!is.null(input$categories)) {
      data %>% select(City, input$categories)
    } 
  })
  
  output$pollut_plot <- renderPlot({
    plot <- ggplot(data = selected_df()) + 
      geom_point(mapping = aes(x = data["AQI (US EPA)"], 
                               y = data[input$select], 
                               color = 
                                 (Latitude %in% reactive_vars$selected_value)),
                 na.rm = TRUE, 
                 stat = "identity",
                 
                 size = 4
      ) +
      guides(color = FALSE) +
      labs(title = paste0(input$select, " by AQI (US EPA)"),
           x = "AQI (US EPA)",
           y = input$select
      )
    add_theme(plot)
    
  })
  
  output$map_plot <- renderPlot({
    map
  })
  
  output$stats <- renderText({
    paste0("In the chosen category: ", input$select, ", the maximum value is ",
           max(data[input$select]), ", the minimum value is ", 
           min(data[input$select]), ", and the average is ", 
           sum(data[input$select]) / 20)
  })
  
  output$map_stats <- renderText({
    table <- nearPoints(data, input$plot_click2)
    table <- rename(table, AQI="AQI (US EPA)")
    if (nrow(table) > 0) {
      paste0("City: ", table$City, ", AQI: ", table$AQI, ", Temperature: ", 
             table$Temperature, "C")
    } else {
      paste("Click the points on the Map.")
    }
  })
}

shinyServer(my_server)