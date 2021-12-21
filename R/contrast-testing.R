# Testing contrasts

library("tidyverse")
source(here::here("R", "contrast-function.R"))

# y = b0 + b1x1 + b2x2
# where x1 is continuous
# and x2 is a 2-level factor (indicator variable)

b0 = -0.1
b1 = 0.3
b2 = 0.1
n = 100

dat <- tibble(
  x1 = rnorm(n),
  x2 = rep(c(1,0), n/2)
) %>%
  mutate(prob = plogis(b0 + b1*x1 + b2*x2)) %>%
  mutate(y = rbinom(n(), 1, prob))

mod <- glm(y ~ x1 + x2, data = dat, family = binomial(link = "logit"))
summary(mod)

# Change from 0 to 1 should be same for standardized cov
contrast.glm(mod, list(x1 = 0, x2 = 0), list(x1 = 1, x2 = 0))

# Calculates difference on link scale
# Provides SE for difference, is it the same as the sum of the SEs? 
# Shouldn't be because I think contrast() accounts for covariance


# Compare to predict
preddat <- tibble(
  x1 = c(0, 1),
  x2 = c(0, 0)
)

res <- predict(mod, preddat, se.fit = TRUE)
res$se.fit %>% sum() # SE from contrast is actually smaller, and smaller than either se
