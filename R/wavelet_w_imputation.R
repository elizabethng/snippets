# Wavelet Analysis and Time Series Imputation

# Wavelet analysis is a way of evaluating periodic time series
# https://www.uqar.ca/uqar/recherche/unites_de_recherche/chaire_biodiversite_nordique/publications/2008cazellesetaloecologia.pdf
# Here, use the WaveletComp package, available on Cran with instructions below
# http://www.hs-stat.com/projects/WaveletComp/WaveletComp_guided_tour.pdf

# However, wavelet analysis needs a time series without ANY missing data
# but many time series will have some missing info. So use a time-series
# imputation package to handle the missing value. Here, I'll use imputeTS
# https://cran.r-project.org/web/packages/imputeTS/vignettes/imputeTS-Time-Series-Missing-Value-Imputation-in-R.pdf


library("imputeTS")
library("WaveletComp")
library("tidyverse")


# 01. Generate Data -------------------------------------------------------
# Example time series with missing observations
set.seed(435)
x <- WaveletComp::periodic.series(start.period = 50, length = 1000)
x <- x + 0.2*rnorm(1000) # add some noise
missing <- sample(1000, 10)
x_na <- replace(x, missing, NA)


# 02. Time Series Imputation ----------------------------------------------
xts <- ts(x_na)
plot(xts)

# visualize missing observations
ggplot_na_distribution(xts)
ggplot_na_distribution2(xts) # shows relative distribution over time, very few missing!

# perform 3 methods of imputation to compare
xts_mn <- na_mean(xts) # mean value
xts_ln <- na_interpolation(xts) # linear interpolation
xts_km <- na_kalman(xts) # kalman filter, good for seasonal trends

ggplot_na_imputations(xts, xts_mn, x) # mean isn't that great
ggplot_na_imputations(xts, xts_ln, x) # linear interpolation is better
ggplot_na_imputations(xts, xts_km, x) 

# compare imputed values
imp_comp <- tibble(
  true = x,
  missing = xts, 
  mean = xts_mn,
  linear = xts_ln,
  kalman = xts_km
) %>%
  filter(is.na(missing)) %>%
  select(-missing)

imp_comp # compare true values and different imputation methods
imp_comp %>% 
  pivot_longer(-true) %>%
  mutate(se = (value - true)^2) %>%
  group_by(name) %>%
  summarize(sse = sum(se))
# kalman minimizes the sum of squared errors here
# (obviously normally won't know truth to pick best)

mydata <- data.frame(t = 1:1000, x = xts_km)
  

# 03. Wavelet Analysis ----------------------------------------------------
# Do wavelet analysis
myw <- WaveletComp::analyze.wavelet(mydata, "x",
                                    loess.span = 0,
                                    dt = 1, dj = 1/250,
                                    lowerPeriod = 16,
                                    upperPeriod = 128,
                                    make.pval = TRUE, n.sim = 10)

# visualize wavelet power spectrum
WaveletComp::wt.image(myw, color.key = "quantile", n.levels = 250,
                      legend.params = list(lab = "wavelet power levels", mar = 4.7))

# reconstruct time series
WaveletComp::reconstruct(myw, plot.waves = FALSE, lwd = c(1,2),
                         legend.coords = "bottomleft")
