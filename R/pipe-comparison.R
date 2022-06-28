# Interesting case where base R pipe is MUCH faster than tidyverse pipe
# From clean_tag_out_files.R in chelan_2022

library("tidyverse")

t0<-Sys.time()
tag_files <- list.dirs("S:/at_2022/at_data/prepped_data") %>%
  `[`(grep("_tagging_", .)) %>%
  list.files(full.names = TRUE) %>%
  `[`(str_ends(., "_venSpec.csv", negate = TRUE))
Sys.time()-t0

t2 <- Sys.time()
tag_files <- list.dirs("S:/at_2022/at_data/prepped_data") |>
  (function(x) x[(grep("_tagging_", x))])() |>
  list.files(full.names = TRUE) |>
  (function(x) x[(str_ends(x, "_venSpec.csv", negate = TRUE))])()
Sys.time - t2