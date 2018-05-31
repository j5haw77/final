library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")
source("map.R")

ui <- fluidPage(
  tags$head(tags$style(".checkbox-inline {margin: 0 !important;}")),
  titlePanel("Washington Air & Weather"),
  br(),
  p("This project analyzes and visualizes environmental data received from the
    Air Visual database for the 20 most populous cities in Washington with 
    information on the database on May 28th, 2018. This data includes 
    information on multiple measurements of the environment, including 
    temperature, atmospheric pressure, wind speed, and pollution for the 
    48-hour period prior to data acquisition."),
  br(),
  tabsetPanel(
    tabPanel("Table",
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput(
                   inputId = "categories",
                   label = "Categories",
                   choices = c("Humidity", "Atm Pressure", "Temperature",
                               "Wind Direction", "Wind Speed", "AQI (US EPA)", 
                               "Main Pollutant (US)", "AQI (CN MEP)",      
                               "Main Pollutant (CN)", "Latitude", "Longitude"),
                   selected = c("Humidity", "Atm Pressure", "Temperature", 
                                "Latitude", "Longitude"),
                   inline = TRUE
                 )
               ),
               mainPanel(
                 h1("Table"),
                 p("The table below shows various data for each city. Which data is
                   displayed can be selected via the control panel."),
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
                               "Wind Speed", "AQI (US EPA)")
                 ),
                 br(),
                 tableOutput("chosen_value"),
                 textOutput("stats")
                 
               ),
               mainPanel(
                 plotOutput("pollut_plot", click = "plot_click")
               )
             )
    ),
    tabPanel("Map", plotOutput("map_plot"))
    ),
  br(),
  h1("Data Documentation"),
  p("The data presented here originated from Air Visual, a company that
    manufactures home air quality monitors and gathers data from weather
    stations around the world.",
    a(href = "https://www.airvisual.com/api", "Here's a link to their website.")
  ),
  p()
  )

shinyUI(ui)