library(shiny)
library(dplyr)
library(ggplot2)
library(DT)

source("analysis.R")

ui <- fluidPage(
  titlePanel("Washington Air & Weather"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput(
        "categories",
        colnames(values)
      ),
      selectInput(
        "select",
        label = "Select a category:",
        colnames(values)
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
