# Check CIs

# In repsonse to email from Sam about calculating 95% CIs for expanded counts
# from fish counting, for comparison to the DNN cam. 

library("tidyverse")
set.seed(889)

# Do for one --------------------------------------------------------------
# Chinook observed in 1 full hour
n <- rpois(1, 100)

# fraction counted 
frac <- 50/60
a <- 1/frac

# n obs
x_bar <- frac*n

# What is the variance of a single count?
# --> for poisson random variable it's the mean
var_x <- x_bar

# Get expanded counts
mean_total <- a*x_bar
var_total <- a^2*var_x

# appx CI
lcb <- mean_total - 1.96*sqrt(var_total)
ucb <- mean_total + 1.96*sqrt(var_total)


# Do for a bunch to check nominal coverage --------------------------------
a <- 60/50
nsims <- 10^5
nvals <- 100

simdat <- tibble(
  true_mean = seq(1, 100, length.out = nvals)
) %>%
  expand_grid(sim_id = 1:nsims) %>%
  mutate(
    draw = rpois(nsims*nvals, true_mean)/a,
    obs_mean = draw*a,
    total_var = (a^2)*obs_mean,
    lcb = obs_mean - 1.96*sqrt(total_var),
    ucb = obs_mean + 1.96*sqrt(total_var),
    covered = true_mean > lcb & true_mean < ucb)

simres <- simdat %>%
  group_by(true_mean) %>%
  summarize(
    obs_mean = mean(draw),
    coverage_rate = 100*mean(covered)
  )

ggplot(simres, aes(x = true_mean, y = coverage_rate)) +
  geom_point()


