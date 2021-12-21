# Perform model selection with a subset of covariates
# Initially in BPA Chinook fallback analysis (Github repo: chinook-overshoot-bpa)


library("tidyverse")
library("MuMIn")


# 01. Format data ---------------------------------------------------------
moddat <- tibble(mtcars) %>%
  mutate(
    disp_log = log(disp),
    hp_log = log(hp)
  )

# 2. Specify global model --------------------------------------------------
global <- lm(mpg ~ .,data = moddat, na.action = na.fail)

# 3. Dredge models -----------------------------------------------------------
# Don't include both log scale and original scale covariates
mysubset <- expression(!(disp && disp_log) && !(hp && hp_log))


ranked <- dredge(global, subset = mysubset, extra = alist(BIC)) 
top_mods <- subset(ranked, delta < 2)
best_mod <- get.models(top_mods, subset = delta == 0)[[1]]

# Note that this will fail if the term is not in the dataset