# Example of pmap usage

mytest <- mytest %>%
  dplyr::mutate(run_name = purrr::pmap_chr(
    list("diet", pdcomnam, myseason, covar_columns, config_file_loc),
    make_run_name
  ))