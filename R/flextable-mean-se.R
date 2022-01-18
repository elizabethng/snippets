# Format a table with grouped mean and SE columns, a common output for estimates
# Here, also include a summary column with mean and SE

library("tidyverse")
library("enutils")
library("flextable")

set.seed(9384)

# 0. Make an example wide data set
dat <- tibble(
  group = LETTERS[1:4],
  mean = 10*1:4,
  se = rgamma(4, 1, 1)
) %>%
  expand_grid(
    year = 2015:2020
  ) %>%
  mutate(
    mean = rpois(n(), mean),
    se = abs(rnorm(n(), se, 1))
  )

# 1. Format the data into desired wide forma
# Found that it helps to add the additional step of pivoting longer first
tabdat <- dat %>%
  pivot_longer(
    cols = c(mean, se), 
    names_to = "sub_header"
  ) %>%
  mutate(
    group = paste(group, sub_header, sep = "_") # include another prefix here to reorder if desired
  ) %>%
  select(year, group, value) %>%
  # arrange(group) %>% # reorder according the the new prefix
  pivot_wider(
    names_from = group, 
    values_from = value
  ) %>%
  rowwise() %>%
  mutate(
    Total_mean = sum(across(ends_with("_mean"))),
    Total_se = ssqvec(across(ends_with("_se")))
  ) %>%
  rename(Year = year)

# 2. Create the label key to create header and sub-headers
labs <- tibble(col_keys = names(tabdat)) %>%
  separate(
    col_keys, 
    into = c("line2", "line3"), 
    sep = "_",
    fill = "right",
    remove = FALSE
  ) %>%
  mutate(
    line2 = gsub("\\d+\\.", "", line2), # remove ordering prefix, if added (here assumes format 1.)
    line3 = ifelse(line3 == "mean", "Mean", "SE")
  )

# 3. Create the flextable object
ftab <- tabdat %>%
  flextable(col_keys = labs$col_keys) %>%
  colformat_double(j = c(3,5,7,9,11), digits = 1) %>%
  set_header_df(mapping = labs, key = "col_keys") %>%
  merge_v(part = "header", j = 1) %>%
  merge_h(part = "header", i = 1) %>%
  theme_booktabs() %>% 
  align(align = "center", part = "all") %>%
  align(align = "left", part = "body", j = 1) %>%
  autofit()
ftab  

# 4. Save the ouput in a Word document
if(FALSE){
  read_docx() %>%
    body_add_par("Results") %>%
    body_add_par("\n") %>%
    body_add_par("\n") %>%
    body_add_flextable(value = ftab) %>%
    print(target = here::here("results.docx"))
}
