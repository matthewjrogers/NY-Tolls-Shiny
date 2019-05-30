# server <- function(input, output, session){
#   
#   on_off_map_data <- reactive({
#     
#     min_hours <- min(input$hour_of_day)
#     max_hours <- max(input$hour_of_day)
#     
#     if(min_hours != max_hours){
#       hour_range <- c(min_hours:max_hours)
#     } else{
#       hour_range <- min_hours
#     }
#     
#     if(input$action_type == "Entering"){
#       
#       filtered_hourly_toll_data <- hourly_toll_data %>% 
#         filter(action == "entrance",
#                weekday %in% input$day_of_week,
#                hours %in% hour_range)
#     } else {
#       
#       filtered_hourly_toll_data <- hourly_toll_data %>% 
#         filter(action == "exit",
#                weekday %in% input$day_of_week,
#                hours %in% input$hour_of_day)
#     }
#     
#     return(filtered_hourly_toll_data)
#   })
#   
#   output$hourly_on_off_map <- renderLeaflet({
#     map <- leaflet(data = on_off_map_data()) %>% 
#       addTiles() %>% 
#       addCircleMarkers(lng = ~longitude,
#                        lat = ~latitude,
#                        popup = paste("N = ", on_off_map_data()$total),
#                        radius = ~total/10)
#   })
# }