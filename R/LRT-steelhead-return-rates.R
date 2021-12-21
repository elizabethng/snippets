# Test for differences in Steelhead return success, given overshoot status 
# and spill regime. 

library("tidyverse")

# Get the data into a format for analysis. Reference categories are
# spill_regime == "low" as reference and overshoot = FALSE
dat <- tibble(
  spill_regime = factor(c("low", "low", "high", "high"), levels = c("low", "high")),
  overshoot = c(TRUE, FALSE, TRUE, FALSE),
  successes = c(427, 310, 96, 69),
  failures = c(424, 481, 43, 78)
)

# Check observed success rates:
# - In low spill regime, overshoot fish have a higher return rate than non-overshoot
# - In high spill regime, overshoot fish still have a higher return rate
# - High spill regime return rates are higher than low spill regime return rates
#   for both groups of fish
mutate(dat, return_rate = 100*successes/(successes + failures))


# Scientific question for analysis: 
# Does relationship between return rate and overshoot vary with spill_regime?
# Statistical question for analysis:
# Is there a significant interaction between overshoot and spill regime?

# Fit null model with no interaction
mod0 <- glm(cbind(successes, failures) ~ overshoot + spill_regime, 
            family = binomial(link = "logit"),
            data = dat)
summary(mod0)
car::Anova(mod0) 
# Significant effects of overshoot (higher return rates) and high spill (higher return rates)

mod1 <- glm(cbind(successes, failures) ~ overshoot*spill_regime, 
           family = binomial(link = "logit"),
           data = dat)
summary(mod1)
car::Anova(mod1, type = "III")
# Looking at the significance of the interaction here, and does not quite reach
# significance at the alpha = 0.05 level

# Confirm with a likelihood ratio, testing for difference between null model
# (no interaction) and full model (with interaction):
anova(mod1, mod0, test = "LRT")
# Confirms that the interaction term is not significant at the 0.05 level. 