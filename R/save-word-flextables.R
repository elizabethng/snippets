library("tidyverse")
library("officer")
library("flextable")

# Do some calculations on an example data set
my_data <- mtcars %>%
  group_by(cyl) %>%
  summarize(
    Mean = mean(mpg),
    SD = sd(mpg)
  ) %>%
  rename("Number of cylinders" = cyl)

print(my_data)

# Create and format the flextable object
my_flextable <- my_data %>%
  flextable() %>%
  colformat_double(j = 2:3, digits = 2) %>%
  add_header_row(values = c("", "Miles per gallon"), colwidths = c(1, 2)) %>%
  vline(j = 1)

# Save output by 
read_docx() %>%                                  # creating a null .docx object
  body_add_flextable(value = my_flextable) %>%   # insert our flextable object
  print(target = "test.docx")                    # print the output


# Info on creating landscape tables
# Useful for grouped variables with repeated columns of summary statistics,
# Use the labels table to define column and name order to keep things simpler
out <- my_data %>%
  pivot_wider(names_from = `Number of cylinders`, values_from = c(Mean, SD))

# Then create a separate table with labels
outlabs <- tibble(col_keys = names(out)) %>%
  separate(col_keys, 
           into = c("line3", "line2"), 
           sep = "_",
           fill = "right",
           remove = FALSE) %>%
  relocate(line3, .after = everything()) %>% # re-arrange column order here
  arrange(line2, line3) # do this instead of re-ordering above!

tab <- out %>%
  flextable(col_keys = outlabs$col_keys) %>%
  colformat_double(j = c(1:6), digits = 2) %>%
  set_header_df(mapping = outlabs, key = "col_keys") %>%
  merge_v(part = "header", j = 1) %>%
  merge_h(part = "header", i = 1) %>%
  theme_booktabs() %>% 
  align(align = "center", part = "all") %>%
  align(align = "left", part = "body", j = 1) %>%
  add_header_row(values = c("Number of cylinders"), colwidths = 6) %>%
  autofit()
tab  


# Scratch work for more complicated approach
# pivot_wider(names_from = `Number of cylinders`, 
#             values_from = c(Mean, SD),
#             names_glue = "{`Number of cylinders`}_{.value}",
#             names_sort = FALSE) %>%
#  relocate(`4_Mean`, `4_SD`, `6_Mean`, `6_SD`, `8_Mean`, `8_SD`)