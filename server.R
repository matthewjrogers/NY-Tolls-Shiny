server <- function(input, output, session){
  
  # Reactives -----------------------------------------------------------
  
  hour_range <- reactive({
    # Translate slider input to c(min:max) vs. c(min, max)
    hour_range <- get_slider_range(input$hour_of_day_on_off)
  })
  
  on_off_map_data <- reactive({
    req(hour_range)
    
    # Filter Data
    filtered_on_off_data <- on_off_data %>% 
      filter(action == input$action_type,
             weekday %in% input$day_of_week_on_off,
             hours %in% hour_range())
    
    return(filtered_on_off_data)
  })
  
  busiest_exits <- reactive({
    
    busiest_exits<- get_busiest_exit(on_off_data)
    
    busiest_exits %<>% 
      filter(weekday %in% input$day_of_week_on_off) %>% 
      mutate(weekday = wday(weekday, label = T))
    
    return(busiest_exits)
  })
  
  # Render UI: Map N Filter (enables dynamic range of entrances/exits) --------------------
  output$n_selector_on_off <- renderUI({
    req(on_off_map_data())

    max_actions <- max(on_off_map_data() %>%
                         filter(action == input$action_type,
                                hours %in% hour_range()) %>%
                         select(total) %>%
                         pull())

    tagList(
      sliderInput("filter_n_on_off",
                  label = "Filter by Number of Entrances/Exits",
                  min = 1,
                  max = max_actions,
                  value = c(1, max_actions)
      )
    )

  })
  
  
  
  # On-Off Map Output -------------------------------------------------------
  
  output$hourly_on_off_map <- renderLeaflet({
    req(input$filter_n_on_off)
    
    action_range <- get_slider_range(input$filter_n_on_off)
    
    map <- leaflet(data = on_off_map_data() %>% 
                     filter(total %in% action_range)) %>% 
      addTiles() %>% 
      addCircleMarkers(lng = ~longitude,
                       lat = ~latitude,
                       # Note: The following is an admittedly inelegant solution to a filtering problem
                       # If a filter for total is included in the data reactive, the dynamic N filter shrinks each time it is adjusted
                       # However, if it is used in the data argument to leaflet(), as I elected to do, the hover information displays 
                       # incorrect information without a corresponding filter
                       # I opt here for a pragmatic solution while I search for a better alternative
                       popup = paste0("Exit ", on_off_map_data()$exit_num[on_off_map_data()$total %in% action_range], ": ", 
                                      on_off_map_data()$exit_name[on_off_map_data()$total %in% action_range], 
                                      "<br>Total ", on_off_map_data()$action[on_off_map_data()$total %in% action_range],"s: ", 
                                      on_off_map_data()$total[on_off_map_data()$total %in% action_range]),
                       radius = ~total/10)
  })
  
  
  # Busiest Exit Table --------------------------------------------------
  output$busiest_exit_table <- DT::renderDT({
    datatable(busiest_exits(),
              rownames = F,
              colnames = c("Exit Number",
                           "Exit Name",
                           "Day of Week",
                           "Action",
                           "Total"),
              options = list(dom = 't'))
  })
  
}


