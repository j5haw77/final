library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")

#choices = c("Humidity" = "Humidity", "Weather Icon" = "Weather.Icon.Code", 
#            "Atm Pressure" = "ATM.Pressure", "Temperature" = "Temperature", 
#            "Wind Direction" = "Wind.Direction", "Wind Speed" = "Wind.Speed", 
#            "AQI (US EPA)" = "AQI.US.EPA", 
#            "Main Pollutant (US)" = "Main.Pollutant.US", 
#            "AQI (CN MEP)" = "AQI.CN.MEP",      
#            "Main Pollutant (CN)" = "Main.Pollutant.CN"),

ui <- fluidPage(
  titlePanel("Washington Air & Weather"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId = "categories",
        label = "Categories",
        choices = c("Humidity" = "Humidity", "Weather Icon" = "Weather.Icon.Code", 
                    "Atm Pressure" = "ATM.Pressure", "Temperature" = "Temperature", 
                    "Wind Direction" = "Wind.Direction", "Wind Speed" = "Wind.Speed", 
                    "AQI (US EPA)" = "AQI.US.EPA.", 
                    "Main Pollutant (US)" = "Main.Pollutant.US.", 
                    "AQI (CN MEP)" = "AQI.CN.MEP.",      
                    "Main Pollutant (CN)" = "Main.Pollutant.CN."),
        selected = c("Humidity", "ATM.Pressure", "Temperature"),
        inline = TRUE
      ),
      selectInput(
        "select",
        label = "Select a category:",
        colnames(data)
      )
    ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Table", 
                 DT::dataTableOutput("data_table")),
        tabPanel("Plot", 
                 plotOutput("plot", click = "plot_click"))
        )
    )
  )
)

shinyUI(ui)
