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
  h1("Introduction"),
  p("This project analyzes and visualizes environmental data received from the
    Air Visual database for the 20 most populous cities in Washington with 
    information on the database on May 28th, 2018. This data includes 
    information on multiple measurements of the environment, including 
    temperature, atmospheric pressure, wind speed, and pollution for the 
    48-hour period prior to data acquisition."),
  br(),
  h2("Interactive Table & Plots"),
  tabsetPanel(
    tabPanel("Table",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput(
            inputId = "categories",
            label = "Categories",
            choices = c("City", "Humidity(%)", "Atm Pressure(hPa)", 
                        "Temperature(°C)", "Wind Direction(°)", "Wind Speed(mph)", 
                        "AQI (US EPA)", "Main Pollutant (US)", "AQI (CN MEP)", 
                        "Main Pollutant (CN)", "Latitude", "Longitude"),
            selected = c("City", "Humidity(%)", "AQI (US EPA)", "Temperature(C)", 
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
            choices = c("Humidity(%)", "Atm Pressure(hPa)", "Temperature(°C)", 
                        "Wind Speed(mph)", "AQI (US EPA)")
          ),
          br(),
          textOutput("stats"),
          br(),
          tableOutput("chosen_value")
        ),
        mainPanel(
          plotOutput("pollut_plot", click = "plot_click")
        )
      )
    ),
    tabPanel("Map", 
      sidebarLayout(
        sidebarPanel(
          p("Click the points on the Map."),
          p("Results show below:"),
          textOutput("map_stats")
        ),
        mainPanel(
          plotOutput("map_plot", click = "plot_click2")
        )
      )
    )
  ),
  br(),
  h2("Data Documentation"),
  p("The data presented here originated from Air Visual, a company that
    manufactures home air quality monitors and gathers data from weather
    stations around the world.",
    a(href = "https://www.airvisual.com/api", "Here's a link to their website."),
    br(),
    "Each category of data obtained from Air Visual is explained below:",
    tags$ul(
      tags$li("Humidity: Percentage of water vapor content in the air
              relative to the maximum amount possible for the air temperature."),
      tags$li("Atm Pressure: The amount of pressure exerted by the air, measured
              in hectopascals (hPa)."),
      tags$li("Temperature: Measured in degrees Celsius."),
      tags$li("Wind Direction: Measured in degrees clockwise from due north."),
      tags$li("Wind Speed: Measured in miles per hour."),
      tags$li("AQI: The Air Quality Index is a rating given by the EPA representing
              how polluted an area's air is at time of measurement, from
              between 0 and 500. A rating below 50 is considered clean, while
              a rating over 100 is considered dangerous.")
    )
  )
)

shinyUI(ui)
