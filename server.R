# server for shiny app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

my_server <- function(input, output) {
  reactive_vars <- reactiveValues()
  
  selected_df <- reactive({
    data %>% select(City, input$select, "Latitude", "Longitude")
  })
  
  observeEvent(input$plot_click, {
    selected <- nearPoints(selected_df(), 
                           input$plot_click, 
                           xvar = "City", 
                           yvar = input$select)
    colnames(selected) <- c("City", input$select, "Latitude", "Longitude")
    reactive_vars$selected_value <- selected
    if (nrow(selected) == 0) {
      reactive_vars$selected_value <- NULL
    }
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
      geom_point(mapping = aes(x = City, 
                               y = data[input$select], 
                               color = 
                                 (Latitude %in% reactive_vars$selected_value)),
                 na.rm = TRUE, 
                 stat = "identity", 
                 size = 4
                ) +
      guides(color = FALSE) +
      labs(title = paste0(input$select, " by Cities"),
           x = "Cities",
           y = input$select
      )
    add_theme(plot)
    
  })
  
  output$map_plot <- renderPlot({
    map
  })
  output$stats <- renderText({
    paste0("Max = ",max(data[input$select]), 
           " Min = ",min(data[input$select]),
           " Average = ",sum(data[input$select]) / 20)
  })
}

shinyServer(my_server)
