get_slider_range <- function(slider_input){
  input_range <- c(min(slider_input):max(slider_input))
  
  return(input_range)
}