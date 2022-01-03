# Pass options to a ggplot object using a list

# If multiple plots will have the same elements, aesthetics, or both,
# put the options in a list to avoid re-typing. 

# Code from twitter, forget which account
# But see also https://twitter.com/kara_woo/status/1222991722084323328

library("ggplot2")
library("palmerpenguins")
library("patchwork")

common_geoms <- list(
  geom_point(size = 1, shape = 6, color = "#B22222"),
  scale_x_continuous(expand = expansion(0.25)),
  labs(title = "Some General Title"),
  theme_linedraw(8),
  theme(plot.title.position = "plot")
)

p1 <- ggplot(iris) + 
  aes(x = Sepal.Length, y = Petal.Length) +
  common_geoms

p2 <- ggplot(penguins) +
  aes(x = bill_length_mm, y = flipper_length_mm) +
  common_geoms

p1 + p2


