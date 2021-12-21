# I always want to make contour plots that aren't density plots of count data. 
# Here's a good tutorial for how to do that. 

# https://www.r-statistics.com/2016/07/using-2d-contour-plots-within-ggplot2-to-visualize-relationships-between-three-variables/

library("tidyverse")

mtcars$quart <- cut(mtcars$qsec, quantile(mtcars$qsec))

ggplot(mtcars, aes(x = wt, y = hp, color = factor(quart))) +
  geom_point(shape = 16, size = 5) +
  # theme(legend.position = c(0.80, 0.85)) +
  labs(x = "Weight (1,000lbs)",  y = "Horsepower") +
  scale_colour_manual(values = c(
    "#fdcc8a", "#fc8d59", "#e34a33", "#b30000"),
    name = "Quartiles of qsec",
    labels = c("14.5-16.9s", "17.0-17.7s", "17.8-18.9s", "19.0-22.9s"))

