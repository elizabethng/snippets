# Change the names of a named vector (in place) using a pipe

library("tidyverse")
library("palmerpenguins")

# Wrongly named vector
mycolors <- list(
  "a" = rgb(66, 112, 221, max = 255), # red
  "b" = rgb(212, 73, 88, max = 255)   # blue
)

# Stand alone example
`names<-`(mycolors, c("male", "female"))

# Example in use
ggplot(penguins, aes(x = year, y = body_mass_g, color = sex)) +
  geom_point() + 
  scale_color_manual(values = `names<-`(mycolors, c("male", "female"))) +
  facet_grid(species ~ island) +
  theme_en() +
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf) +
  annotate("segment", x = -Inf, xend = -Inf, y = -Inf, yend = Inf)
