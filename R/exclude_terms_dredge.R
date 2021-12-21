# Perform model selection with a subset of covariates
# Initially in BPA chinook fallback analysis

library("tidyverse")
library("MuMIn")


# 01. Format data ---------------------------------------------------------

moddat <- tibble(mtcars)

# 2. Specify global model --------------------------------------------------
global <- lm(
  fallback ~ 
    year_f +
    spill_pct + 
    outflow_kcfs + log_outflow_kcfs +
    wtemp_forebay + log_forebay_temp +
    ascent_hours_mean + log_ascent_time +
    rear_type_f + 
    transport_f + 
    ocean_age,
  family = binomial(link = "logit"),
  data = scaledat
)

# 3. Dredge models -----------------------------------------------------------
# Don't include both log scale and original scale covariates
mysubset <- expression(
  !(outflow_kcfs && log_outflow_kcfs) && 
    !(wtemp_forebay && log_forebay_temp) && 
    !(ascent_hours_mean && log_ascent_time)
)

modset <- dredge(global, subset = mysubset, evaluate = FALSE) # 432 models
write_lines(modset, here_("output", paste0(prefix, "_01_model_set.txt")))

ranked <- dredge(global, subset = mysubset, extra = alist(BIC)) 
write_csv(ranked, here_("output", paste0(prefix, "_02_full_ranked.csv")))

top_mods <- subset(ranked, delta < 2)
write_csv(top_mods, here_("output", paste0(prefix, "_03_top_ranked.csv")))

best_mod <- get.models(top_mods, subset = delta == 0)[[1]]