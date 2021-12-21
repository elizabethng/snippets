# A paired correlation plot
# Can take a long time to run for large data sets


dat <- tibble(
  x = rnorm(100),
  y = rpois(100, 10),
  z = rgamma(100, 0.5)
)

PerformanceAnalytics::chart.Correlation(dat, histogram = TRUE)
