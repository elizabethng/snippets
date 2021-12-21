# Manual model selection example (logistic regression)


# Helper functions
mod_fun <- function(formula){
  glm(formula, family = binomial(link = "logit"), data = mdat)
}
safe_mod <- safely(mod_fun)
make_pred <- function(x){
  paste0(x, collapse = " + ")
}

# Get all combinations of covariates
allpreds <- expand_grid(
  covs = list(c("basin_f", "rear_f", "year_f", "age_z", "overshoot_f")),
  n_sel = 1:5
) %>%
  mutate(preds = map2(covs, n_sel, ~ combn(.x, .y, make_pred))) %>%
  select(preds) %>%
  unnest_longer(preds)

# Fit all the models
allmods <- tibble(
  formula = paste0("returned ~ ", allpreds$preds)
) %>%
  #   slice(c(1, 31)) %>%
  mutate(result = map(formula, safe_mod)) %>%
  mutate(
    error = map(result, "error"),
    model = map(result, "result")
  ) %>%
  mutate(failed = map_lgl(error, ~ ifelse(is.null(.x), FALSE, TRUE)))

filter(allmods, failed) %>% print(n = Inf)

# Extract model selection table for top models
allmods %>%
  filter(failed == FALSE) %>%
  mutate(
    aic = map_dbl(model, AIC),
    npar = map_int(model, ~ length(coef(.x))),
    ests = map(model, broom::tidy),
    delta = aic - min(aic)
  ) %>%
  arrange(aic)