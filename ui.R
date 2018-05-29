library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")

ui <- fluidPage(
  titlePanel("Washington Air & Weather"),
  tabsetPanel(
    tabPanel("Table",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput(
            inputId = "categories",
            label = "Categories",
            choices = c("Humidity", "Atm Pressure", "Temperature", 
                        "Wind Direction", "Wind Speed", "AQI(US EPA)", 
                        "Main Pollutant(US)", "AQI(CN MEP)",      
                        "Main Pollutant(CN)"),
            selected = c("Humidity", "Atm Pressure", "Temperature"),
            inline = TRUE
          )
        ),
        mainPanel(
          DT::dataTableOutput("data_table")
        )
      )
    ),
    tabPanel("Plot",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "select",
            label = "Select a category:",
            choices = c("Humidity", "Atm Pressure", "Temperature", 
                        "Wind Speed")
          )
        ),
        mainPanel(
          plotOutput("pollut_plot", click = "plot_click")
        )
      )
    )
  )
)

shinyUI(ui)
