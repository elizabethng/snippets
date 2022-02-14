# Pass arguments in a list
# From a tweet by @TimTeaFan on 2/13/22

# Method 0 ----------------------------------------------------------------
# Call the function with all of its arguments
mean(c(1:10, NA), trim = 0, na.rm = TRUE)

# Initialize list of arguments
arg_ls <- list(
  x = c(1:10, NA),
  trim = 0,
  na.rm = TRUE
)

# Method 1 ----------------------------------------------------------------
# Base R version
do.call("mean", arg_ls)

# Method 2 ----------------------------------------------------------------
# purrr package
purrr::lift(mean)(arg_ls)
purrr::lift_dl(mean)(arg_ls)

# Method 3 ----------------------------------------------------------------
# big bang operator
# not all functions support this syntax, including `mean`
# need to use rlang::inject to use it
rlang::inject(mean(!!! arg_ls))
