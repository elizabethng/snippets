# Cut vector into discrete parts

# Particularly useful for binning time periods
# Using the labels argument can be a bit confusing, but this SO post explains it well:
# https://stackoverflow.com/questions/38937694/why-does-cut-object-to-my-labels

# The breaks vector needs to be one element longer than the 
# labels argument because the labels are defined *between* the breaks
# Here, added a maxmimum threshold for the category to fix the issue.

grades <- read.table(text="Student Mean
Adam 94
Amanda 85.5
James 81
Noah 72.8333333333333
Zach 57.5", header = TRUE)

letters <- read.table(text = "Letter  Cutoff
A 90
B 80
C 70
D 60
F 0", header = TRUE)

cut(grades$Mean, 
    breaks = c(rev(letters$Cutoff),100), # add 100%
    labels = rev(letters$Letter),
    right = FALSE)

# Application to dates
dat <- seq(lubridate::mdy("01-01-2022"), 
    lubridate::mdy("01-01-2023"),
    by = "1 day")

cats <- data.frame(
  brk = lubridate::mdy("03-01-2022", "06-01-2022", "09-01-2022", "12-01-2022"),
  lab = c("spring", "summer", "fall", "winter")
)

# Would have to add additional category before the start of spring to capture
# the end of 2021-2022 winter
cut(
  dat,
  breaks = c(cats$brk, lubridate::mdy("03-01-2023")),
  labels = cats$lab
)

# This also works, instead of providing a specific value (as long as categories
# are in "ascending" order)
cut(
  dat,
  breaks = c(cats$brk, Inf),
  labels = cats$lab
)
