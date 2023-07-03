# Demonstration of a few different methods for fitting models in a tibble
# framework

library("tidyverse")
library("palmerpenguins") # penguins data set
library("broom")

glimpse(penguins)

# 1. fit the same model to different parts of the data set
dat1 <- penguins %>%
  group_by(species) %>%
  nest() %>%
  mutate(model = map(data, ~ lm(bill_length_mm ~ sex, data = .x))) %>%
  mutate(output = map(model, broom::tidy))

# do for 1 (as an example)
# this is often how I'll often start before writing the `map` function
lm(bill_length_mm ~ sex, data = dat1$data[[2]])

# do stuff to the output to look at
lapply(dat1$model, summary)


# 2. fit several models to the same data set
modset <- c(
  "bill_length_mm ~ sex",
  "bill_length_mm ~ body_mass_g",
  "bill_length_mm ~ body_mass_g*sex"
)

dat2 <- tibble(model = modset) %>%
  mutate(fit = map(model, ~ lm(.x, data = penguins))) %>%
  mutate(aic = map_dbl(fit, AIC))

# 3. fit several models to different data
dat3 <- penguins %>%
  group_by(species) %>%
  nest() %>%
  expand_grid(modset) %>%
  mutate(fit = map2(modset, data, ~ lm(.x, data = .y))) %>%
  mutate(aic = map_dbl(fit, AIC))

dat3 %>%
  select(-data, -fit) %>%
  group_by(species) %>%
  arrange(desc(aic))
