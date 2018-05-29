library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")

ui <- fluidPage(
  titlePanel("Washington Air & Weather"),
  br(),
  p("This project analyzes and visualizes environmental data received from the
    Air Visual database for the 20 most populous cities in Washington with 
    information on the database on May 28th, 2018. This data includes 
    information on multiple measurements of the environment, including 
    temperature, atmospheric pressure, wind speed, and pollution for the 
    48-hour period prior to data acquisition."),
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
          h1("Table"),
          p("The table below shows various data for each city."),
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
