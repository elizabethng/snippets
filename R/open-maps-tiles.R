# Evaluate different Open Maps Tiles available in R


library("tidyverse")
library("sf")
library("ggspatial")

site <- data.frame(longitude = -120.325278, latitude = 47.423333) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

for(lyr in rosm::osm.types()){
  p <- ggplot(site) +
    annotation_map_tile(lyr) +
    ggtitle(lyr) +
    geom_sf(size = 5)
  print(p)
}

