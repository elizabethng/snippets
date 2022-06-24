# Test the use of R.utils to create the appearance of a local directory
# Useful for project oriented workflow where data and code live in separate
# places. 

# see https://tinyurl.com/yyh3qazd 

library("tidyverse")
library("R.utils")
library("here")

# From R, use `R.utils` to create a "virtual" folder
# Creates a windows shortcut to the directory in the current working directory
target_path <- paste0("W:/Shared With Me/Four_Peaks/Projects/Chelan PUD/",
                      "2020 Technical Support/Spill Optimization/4-Data/Raw")
R.utils::createLink(target = target_path)
dir("Raw")
# Creates a shortcut, but `dir` doesn't work.

# Try the "fully cross-platform" approach
path <- R.utils::filePath(target_path, expandLinks = "any")
dir(path)

# But now try it with the shorter, local shortcut location
locpath <- R.utils::filePath("Raw", expandLinks = "any")
dir(locpath)

# Will here work with this?
dir(here("Raw")) #  No...
dir(here(locpath))
dir(here(locpath, "CPUD", "RI Bypass Data"))

dat <- readxl::read_xlsx(here(locpath, "CPUD", "RI Bypass Data", "2010-2019 RI JBT Data.xlsx"))

# How is this different from hardcoding the path?
# Well, I won't be able to use here. But is the end result that different?
dir(here(target_path)) # doesn't work
dir(target_path)

dat2 <- paste0(target_path, "/CPUD/RI Bypass Data/2010-2019 RI JBT Data.xlsx") %>%
  readxl::read_xlsx()

identical(dat, dat2)

# So it is nice to be able to use the here package, but it will still require
# initialization in each script. 
# Also, is it possible to use that with a nested link? That is, if I want to put
# it in a data folder, or write to it an output folder, will that work?
# 1. Manually created shortcut to "Raw" in the data folder
# 2. Make the local path, using here to specify the location
locpath2 <- R.utils::filePath(here("data", "Raw"), expandLinks = "any")
dir(locpath2)
# 3. Test reading data
dat3 <- here(locpath2, "CPUD", "RI Bypass Data", "2010-2019 RI JBT Data.xlsx") %>%
  readxl::read_xlsx()
dat4 <- here("data", "Raw", "CPUD", "RI Bypass Data", "2010-2019 RI JBT Data.xlsx") %>%
  R.utils::filePath(., expandLinks = "any") %>%
  readxl::read_xlsx()

# So this just requires one extra step. I wonder if this is built in to the
# here package? Could do a feature request eventually, or roll my own custom.

# For now, a workflow is
# 1. Set up shortcut to desired file locations
#    - can use R.utils::createLink(target = target_path)
#    - or can set up manually
#    - I don't think there is a big difference, first option is more transparent
# 2. Need to apply R.utils::filePath(., expandLinks = "any") to any here output
# 3. Access files using explanded link. 

# Seems like it will be much cleaner to make my own function, perhaps `here` and
# then don't load the here package??

check <- function(...){
  R.utils::filePath(here::here(...), expandLinks = "any")
}

# Compare
dat5 <- here("data", "Raw", "CPUD", "RI Bypass Data", "2010-2019 RI JBT Data.xlsx") %>%
  R.utils::filePath(., expandLinks = "any") %>%
  readxl::read_xlsx()
dat6 <- check("data", "Raw", "CPUD", "RI Bypass Data", "2010-2019 RI JBT Data.xlsx") %>%
  readxl::read_xlsx()
# It works!

# What happens if I overwrite the name? Is this terrible practice?
here <- function(...){
  R.utils::filePath(here::here(...), expandLinks = "any")
}
dat7 <- here("data", "Raw", "CPUD", "RI Bypass Data", "2010-2019 RI JBT Data.xlsx") %>%
  readxl::read_xlsx()
# So it works, but I should contemplate whether this is the desired approach. 

# Try writing output
write_csv(iris, here("data", "Raw", "test-dat.csv"))

# Perhaps a better option is to make it just slightly different, e.g.
here_ <- function(...){
  R.utils::filePath(here::here(...), expandLinks = "any")
}
write_csv(iris, here_("data", "Raw", "test-dat.csv"))

# potential issues: if the shortcut link doesn't work for everyone using the 
# project. but that will be the same issue if the hard-coded file path doesn't
# work well for people now. As long as the file naming is consistent across
# users, e.g. "W:/Shared with me/...", then it should work in both cases
# Also, this has the added benefit of making there only be one place where
# the paths would need to be updated, as opposed to going through each
# script and updating individual paths. 

# One final question is how these shortcuts will appear on CodeCommit.
# Empty folders aren't tracked by git, so perhaps they won't be either?
# Check what's happening for this repository (although there's no remote).

# They appear as .lnk files (binary file)

# Commit those changes, and then clone repository somewhere else. What happens
# to those shortcuts?

# Tested by cloning to desktop and it worked, shortcuts still point to the
# correct folders.