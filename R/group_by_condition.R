# Goal - count when elevation (value) drops below a threshold (e.g., 612)
# stop counting when it reaches the final bin
# then start counting again when it drops below the threshold

library("tidyverse")

# Make some fake data
set.seed(323)
dat <- tibble(
  value = rpois(n = 50, lambda = 612)
) %>%
  rowid_to_column("id")

# One approach is to make a grouping variable for each set of continuous values
drawdowns <- dat %>%
  # make an indicator for the elevation threshold
  mutate(keep = as.numeric(value < 612)) %>%
  # look at the elevation before to determine whether it is rising or falling
  mutate(lag = lag(keep)) %>%
  # discard the periods that are not below the threshold for simplicity
  filter(keep != 0) %>%
  # For the first time period of the drawdown, the previous value was either NA or 0
  # Assign id (i.e., the time) of the first hour of drawdown as the group variable
  mutate(group = ifelse(is.na(lag) | lag == 0, id, NA)) %>%
  fill(group, .direction = "down")

# Get some summary statistics from the raw data
# duration of each event and the startime (i.e., group)
drawdowns %>%
  group_by(group) %>%
  summarize(duration = n())

# Get the total number of drawdown events
length(unique(drawdowns$group))
