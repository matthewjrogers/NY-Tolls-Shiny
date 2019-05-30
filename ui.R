ui <- navbarPage("New York Thruway Usage, March 20-26 2019",
                 theme = shinytheme("flatly"),
                 tabPanel("Entrances and Exits",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("action_type",
                                          label = "Select Entering or Exiting",
                                          choices = c("Entering" = "entrance",
                                                      "Exiting"  = "exit")),
                              multiInput("day_of_week_on_off",
                                         label = "Select Day(s) of Week",
                                         choices = list("Sunday" = 1,
                                                        "Monday" = 2,
                                                        "Tuesday" = 3,
                                                        "Wednesday" = 4,
                                                        "Thursday" = 5,
                                                        "Friday" = 6,
                                                        "Saturday" = 7
                                         ),
                                         selected = c(7)),
                              sliderInput("hour_of_day_on_off",
                                          label = "Select Hours of Day (Military Time)",
                                          min = 0,
                                          max = 23,
                                          value = c(7,9)),
                              uiOutput("n_selector_on_off"),
                              width = 2
                            ),
                            mainPanel(
                              fluidRow(width = NULL,
                                       column(9,
                                              boxPlus(
                                                title = "Entrances and Exits from New York Thruway",
                                                closable = F,
                                                collapsible = F,
                                                leaflet::leafletOutput("hourly_on_off_map"),
                                                width = 12,
                                                footer = "Source: New York State Department of Transportation"
                                              ),
                                              fluidRow(
                                                column(8,
                                                       boxPlus(
                                                         title = "Busiest Exit(s)",
                                                         closable = F,
                                                         collapsible = F,
                                                         DT::DTOutput("busiest_exit_table"),
                                                         width = 12
                                                       )),
                                                column(4,
                                                       boxPlus(
                                                         title = "Summary",
                                                         closable = F,
                                                         collapsible = F,
                                                         div("This app allows you to interactively explore toll data from the New York State Thruway",
                                                             br(), br(),
                                                             "The sizes of the map bubbles are proportional to the number of Thruway entrances 
                                                             or exits in the selected time range.",
                                                             br(), br(),
                                                             "See the 'About' tab for a brief discussion of the construction of the app."),
                                                         width = 12
                                                       )
                                                )
                                              )
                                       )
                              )
                            )
                          )
                 ),
                 tabPanel("About",
                          fluidRow(width = NULL,
                                   column(7,
                                          includeMarkdown("About.Rmd")
                                   )
                          )
                 )
)