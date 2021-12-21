library("sf")
library("tidyverse")

mypath <- "C:/Users/ElizabethNg/Downloads/ri-forebay-deployment.gpx"
mydat <- st_read(mypath, layer = "waypoints")

dat <- mydat %>%
  select(name) %>%
  arrange(name)

dat$lon <- st_coordinates(dat)[,1]
dat$lat <- st_coordinates(dat)[,2]

write_csv(dat, "C:/Users/ElizabethNg/Downloads/coords.csv")
