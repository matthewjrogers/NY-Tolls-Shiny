
# Set Library -------------------------------------------------------------

library(tidyverse) # data manipulation
library(purrr)
library(R.utils)

library(shiny)
library(shinyWidgets) # improved Shiny UI features
library(shinythemes) # simple formatting
library(shinydashboardPlus)
library(leaflet) # mapping
library(radiant.data)
library(DT)

# Read Data & Source Functions ---------------------------------------------------------------

R.utils::sourceDirectory("Functions")

on_off_data <- read_csv("Clean Data/aggregated_toll_data.csv")
