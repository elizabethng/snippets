# Function to categorize observations as vector of times
# e.g., to assign fish passage date times with ops and environment data
#' Categorize time intervals
#'
#' @param vec vector of fish observation times
#' @param breaks vector of environmental data time stamps
#'
#' @return vector of environmental data times associated with each fish observation
#' @export
#'
#' @examples
#' library(tidyverse)
#' 
#' # Fish observation data
#' fish <- tibble(
#'   fish_id = 1:3,
#'   obs_time = ymd_hm(paste("2023-01-01", c("01:34", "3:59", "09:01")))
#' )
#' 
#' # Environmental data
#' hourly_env_data <- tibble(
#'   datetime = seq(ymd_hm("2023-01-01 00:00"), ymd_hm("2023-01-01 12:00"), by = "hour")
#' ) %>%
#' mutate(metric = rpois(n(), 10))
#' 
#' # Categorize fish observation times and then join back to environmental data
#' fish_w_env <- fish %>%
#'   mutate(env_time = categorize_times(obs_time, hourly_env_data$datetime)) %>%
#'   left_join(hourly_env_data, join_by(env_time == datetime))
#'   
categorize_times <- function(vec, breaks){
  labels <- breaks[-length(breaks)]
  out <- cut(vec, breaks = breaks, labels = labels) %>% 
    as.character() %>%
    as_datetime()
  return(out)
}