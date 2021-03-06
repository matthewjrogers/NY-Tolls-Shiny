
# Set Library -------------------------------------------------------------

library(tidyverse) # data manipulation
library(purrr)
library(lubridate)
library(R.utils)

library(shiny)
library(shinyjs)
library(shinyWidgets) # improved Shiny UI features
library(shinythemes) # simple formatting
library(shinydashboard)
library(shinydashboardPlus)
library(leaflet) # mapping
library(DT)

# Read Data & Source Functions ---------------------------------------------------------------

R.utils::sourceDirectory("Functions")

on_off_data <- read_csv("Clean Data/aggregated_toll_data.csv")
