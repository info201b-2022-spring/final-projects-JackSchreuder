library(shiny)

source("app_ui.R")
source("app_server.R")
# source("chart_1.r")
source("chart_2.r")
source("chart_3.r")

shinyApp(ui = ui, server = server)