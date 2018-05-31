my_server <- function(input, output) {
  reactive_vars <- reactiveValues()
  
  selected_df <- reactive({
    data %>% select(City, "AQI (US EPA)", input$select, Latitude, Longitude, 
                    Population)
  })
  
  observeEvent(input$pollut_plot_click, {
    selected <- nearPoints(selected_df(), 
                           input$pollut_plot_click, 
                           xvar = "AQI (US EPA)", 
                           yvar = input$select)
    colnames(selected) <- c("City", "AQI (US EPA)", input$select, 
                            "Latitude", "Longitude", "Population")
    reactive_vars$selected_value <- selected
    if (nrow(selected) == 0) {
      reactive_vars$selected_value <- NULL
    }
  })
  
  output$plot_city <- renderPlot({
    city_plot <- ggplot(data, aes(x = City, 
                                  y = data[input$button], 
                                  fill = data[input$button])
                       ) + 
      geom_bar(stat = "identity") +
      scale_fill_distiller(palette = "Spectral") + 
      labs(title = paste0(input$button, " by Cities"),
           x = "City",
           y = input$button,
           fill = input$button
      ) +
      theme(
        axis.text.x = element_text(angle=90)
      )
    city_plot <- add_theme(city_plot)
    city_plot
  }, height = 450, width = 650)
  
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
  
  output$pollute_plot <- renderPlot({
    plot <- ggplot(data = selected_df(), 
                   aes(x = data["AQI (US EPA)"], y = data[input$select])) + 
      geom_point(mapping = aes(color = 
                                 (Population %in% reactive_vars$selected_value)),
                 na.rm = TRUE, 
                 stat = "identity",
                 size = 4
      ) +
      geom_smooth(method = lm) +
      guides(color = FALSE) +
      labs(title = paste0(input$select, " by AQI (US EPA)"),
           x = "AQI (US EPA)",
           y = input$select
      )
    add_theme(plot)
  }, height = 420, width = 600)
  
  output$map_plot <- renderPlot({
    map
  }, height = 450, width = 650)
  
  output$stats <- renderText({
    paste0("In the chosen category: ", input$select, ", the maximum value is ",
           max(data[input$select]), ", the minimum value is ", 
           min(data[input$select]), ", and the average is ", 
           sum(data[input$select]) / 40)
  })
  
  output$map_stats <- renderText({
    table <- nearPoints(data, input$map_hover)
    table <- rename(table, AQI="AQI (US EPA)")
    if (nrow(table) > 0) {
      paste0("City: ", table$City, ", AQI: ", table$AQI, ", Population: ", 
             table$Population, ".")
    } else {
      paste("Hover onto the points on the Map to view details.")
    }
  })
  
  output$pop_plot <- renderPlot({
    ggplot(data = data, aes(x = Population, y = data[["AQI (US EPA)"]])) +
      geom_point(mapping = aes(color = Population), size = 4) +
      geom_smooth(method = lm) +
      guides(color = FALSE)+
      labs(y = "Air Quality Index (US EPA) Rating")
  })
}

shinyServer(my_server)