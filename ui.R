library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")

ui <- fluidPage(
  titlePanel("Washington Air & Weather"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "year",
        "Years",
        min = 2000,
        max = 2016,
        value = 2016
      ),
      selectInput(
        "select",
        label = "Select a category:",
        choices = selections
      ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Table", 
                 DT::dataTableOutput("data_table"),
        tabPanel("Plot", 
                 plotOutput("plot", click = "plot_click"), 
                 tags$strong(textOutput("plot_selec"))
                )
        )
      )
    )
  )
)
)

shinyUI(ui)
