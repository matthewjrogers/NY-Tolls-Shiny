get_busiest_exit <- function(aggregated_toll_data){
  
  reduced_data <- aggregated_toll_data %>% 
    group_by(weekday) %>% 
    nest() %>% 
    mutate(data = map(data,
                      ~filter(., total == max(total)))) %>% 
    unnest(cols = c('data')) %>% 
    ungroup()
  
  reduced_data %<>% 
    arrange(exit_num) %>% 
    select(exit_num, exit_name, weekday, action, total)
  
  return(reduced_data)
}
