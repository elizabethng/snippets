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