# LOAD LIBBRARIES

library(jsonlite)
library(readr)
library(data.table)
library(dplyr)
library(shinydashboard)
library(shiny)
library(dashboardthemes)
library(reactable)
library(highcharter)
library(sf)

# BOUNDARY URLS

ccg_url = "https://opendata.arcgis.com/api/v3/datasets/d6acd30ad71f4e14b4de808e58d9bc4c_0/downloads/data?format=geojson&spatialRefId=4326"
stp_url = "https://opendata.arcgis.com/api/v3/datasets/dfbbf1aec521476eb7887d7ee28338e2_0/downloads/data?format=geojson&spatialRefId=4326"
region_url = "https://opendata.arcgis.com/api/v3/datasets/5e33fd1436114a19b335ed07076a4c5b_0/downloads/data?format=geojson&spatialRefId=4326"

# BOUNDARY DATA

ccg_boundary = load_edit_bounary(ccg_url, "CCG21CD")
stp_boundary = load_edit_bounary(stp_url, "STP21CD")
region_boundary = load_edit_bounary(region_url, "nhser20cd")

# LOAD TOTAL DATA

data = read_rds("data/total_items_nic.Rds")

# LOAD FUNCTIONS

source("app/ui.r")
source("app/server.r")
source("app/shiny_functions.r")

# LAUNCH APP

shinyApp(ui, server)
