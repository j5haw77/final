# Defines the User Interface for the Washington Air and Weather app
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(shinythemes)
library(hexbin)
library(tidyr)
library(plotly)
library(grid)

source("./analysis.R")
source("./map.R")

ui <- fluidPage(
  theme = shinytheme("yeti"),
  tags$head(tags$style(".checkbox-inline {margin: 0 !important;}")),
  titlePanel("", "Washington Air & Weather"),
  h1(strong("Washington Air & Weather")),
  h4("By Sam Lee, Dylan Thornsberry, Gordon Duncan, and Jackson Shaw"),
  h3(strong("Introduction")),
  p("This project analyzes and visualizes environmental data received from the
    Air Visual database for the 40 most populous cities in Washington with 
    information on the database on May 28th, 2018. This data includes 
    information on multiple measurements of the environment, including 
    temperature, atmospheric pressure, wind speed, and pollution for the 
    48-hour period prior to data acquisition. In different modules below, you
    will have a chance to explore the data we gathered from the Air Visual
    API by utilizing different control panels on the left."),
  p("Our main focus is on the levels of pollution in various cities in 
    Washington State. Furthermore, we are interested in the relationships
    between pollution levels and other weather factors, such as temperature, 
    atmospheric pressure, and wind speed, as well as populations. We predict
    that population will probably have the strongest correlation with pollution,
    since larger population in the cities implies the greater need for the use 
    of motor vehicles and/or facilities that end up producing and releasing 
    pollutants into the air, such as factories."),
  h3(strong("Washington State Pollution Plots & Table")),
  tabsetPanel(
    tabPanel("Washington Map", 
             sidebarLayout(
               sidebarPanel(
                 p("Results show below:"),
                 p("These stats indicate that, since even the city with the
                   most polluted air has an AQI rating below the 'Moderate'
                   mark of 50, all of the most populous cities in Washington
                   have relatively clean air."),
                 br(),
                 em(textOutput("map_stats"))
                 ),
                mainPanel(
                  plotOutput("map_plot", hover = hoverOpts(id = "map_hover"), 
                             width = "100%")
                )
              )
    ),
    tabPanel("Population Plot",
             sidebarLayout(
               sidebarPanel(
                 p("This plot shows the relationship between the population
                   and Air Quality Index rating (provided by the EPA) for each
                   city."),
                 p("This plot shows that, of the most populous cities in
                   Seattle, there is no significant relationship between
                   population and air pollution."),
                 br(),
                 em(textOutput("pop_stats"))
               ),
               mainPanel(
                 plotOutput("pop_plot", hover = hoverOpts(id = "pop_hover"))
               )
             )
    ),
    tabPanel("Pollution Plot",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   "select",
                   label = "Select a category:",
                   choices = c("Temperature(C)", "Humidity(%)", 
                               "Atm Pressure(hPa)", "Wind Speed(mph)")
                 ),
                 textOutput("stats"),
                 br(),
                 p(em("The category drop-down menu allows you to interact with the plot 
                      on the right by selecting a specific category of data that 
                      you are interested in viewing.")),
                 p(em("By hovering onto the points, text will appear below the plot with
                      city name and AQI rating.")),
                 p(em("By clicking on the points, a smaller table will be generated with 
                      relevant information. The small table below shows the City name, 
                      AQI (US EPA) rating, data of the selected category, the latitude, 
                      and longitude of the clicked point on the graph. 
                      (Initially, there is no table showing)"))
                 ),
               mainPanel(
                 plotOutput("pollute_plot", click = "plot_click",
                            hover = hoverOpts(id = "pollute_hover"), width = "100%"),
                 textOutput("hover_text"),
                 br(),
                 tableOutput("chosen_value")
               )
              )
    ),
    tabPanel("City Plot",
             sidebarLayout(
               sidebarPanel(
                 radioButtons(
                   "button",
                   "Select a category:",
                   c("AQI Pollution Index Score" = "AQI (US EPA)",
                     "Population" = "Population",
                     "Temperature" = "Temperature(C)", 
                     "Wind Speed " = "Wind Speed(mph)")
                  ),
                  p(em("The category radio buttons allow you to interact with the 
                        plot on the right by selecting a specific category of 
                        data that you are interested in viewing."))
               ),
               mainPanel(
                 plotOutput("plot_city", width = "100%")
               )
             )
    ),
    tabPanel("Data Table",
             sidebarLayout(
               sidebarPanel(
                 checkboxGroupInput(
                   inputId = "categories",
                   label = "Categories",
                   choices = c("City", "Population", "Humidity(%)", 
                               "Atm Pressure(hPa)", "Temperature(C)", 
                               "Wind Speed(mph)", "AQI (US EPA)", 
                               "Main Pollutant (US)", "AQI (CN MEP)", 
                               "Main Pollutant (CN)", "Latitude", "Longitude"),
                   selected = c("City", "Population", "AQI (US EPA)", 
                                "Latitude", "Longitude"),
                   inline = TRUE
                 ),
                 p(em('The "Categories" checkboxes above allow you to interact with the 
                      table on the right by checking different categories of data that
                      you wish to view, and the table will display them for you.'))
                 ),
               mainPanel(
                 h1("Table"),
                 p("The table below shows various data for each city."),
                 DT::dataTableOutput("data_table")
               )
              )
    ),
    tabPanel("Q&A",
             br(),
             tags$ol(
               tags$li(p("Q: Is there a correlation between population and level 
                         of pollution?"),
                       p("A: No, based on the point distribution of the plot 
                         there is no strong correlation between population and
                         level of pollution.")
                       ),
               tags$li(p("Q: How heavily polluted are cities in Washington?"),
                       p(paste0("A: According to our plot, Cities in Washington
                                State are not heavily polluted. Based on the 
                                maximum rating of AQI, which is ", max, ", 
                                cities have good air quality with little 
                                potential to affect public health."))
                       ),
               tags$li(p("Q: Are there regions in Washington that are more 
                         polluted than others?"),
                       p("A: According to the Map visualization, the more 
                         polluted cities are located near the Puget Sound. 
                         This is possibly due to high motor vehicle use, a busy
                         harbor and an abundance of factories. However, Yakima,
                         despite being far from Puget Sound is heavily
                         polluted. This is potentially due to large amounts of
                         agricultural activities mixing with motor vehicle 
                         emissions.")),
               tags$li(p("Q: Is there a correlation between humidity and 
                         pollution?"),
                       p(paste0("A: Acording to the plot there is no strong 
                                correlation between humidity and pollution. 
                                We found this surprising because with all the 
                                motor vehicles being used the humidity should 
                                increase because water vapor is a product of 
                                burning gas."))
              )
            )
    )
  ),
  br(), br(), br(),
  h3(strong("Data Documentation")),
  p("The data presented here originated from Air Visual, a company that
    manufactures home air quality monitors and gathers data from weather
    stations around the world.",
    a(href = "https://www.airvisual.com/api", "Here's a link to their website."),
    br(),
    "Categories of data obtained from Air Visual is explained below:",
    tags$ul(
      tags$li("Humidity: Percentage of water vapor content in the air
              relative to the maximum amount possible for the air temperature."),
      tags$li("Atm Pressure: The amount of pressure exerted by the air, measured
              in hectopascals (hPa)."),
      tags$li("Wind Direction: Measured in degrees clockwise from due north."),
      tags$li("AQI (US EPA): The Air Quality Index is a rating given by the EPA 
              representing how polluted an area's air is at time of measurement, 
              from between 0 and 500. A rating below 50 is considered clean, while
              a rating over 100 is considered dangerous."),
      tags$li("AQI (CN MEP): Similar to the US AQI, but measured and maintained
              by China's Ministry of Ecology and Environment"),
      tags$li("Main Pollutant: The pollutant most prevalent in the atmosphere
              for that city, as measured by either the US EPA (US) or
              Chinese MEP (CN). The pollutants are abbreviated as follows:",
              tags$ul(
                tags$li("p2: Atmospheric particulates that have a diameter of
                        less than 2.5 micrometers (pm2.5)"),
                tags$li("p1: Atmospheric particulates that have a diameter
                        between 2.5 and 10 micrometers (pm10)"),
                tags$li("o3: Ozone (O3)"),
                tags$li("n2: Nitrogen dioxide (NO2)"),
                tags$li("s2: Sulfur dioxide (SO2)"),
                tags$li("co: Carbon monoxide (CO)")
              )
      )
    )
  )
)

shinyUI(ui)