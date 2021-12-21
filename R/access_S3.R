# Set up access to S3 buckets
# see info here: https://www.gormanalysis.com/blog/connecting-to-aws-s3-with-r/
library("tidyverse")
library("aws.s3")



# 00. Test saving and removing credentials from environment ----------------
Sys.getenv()

# Save credentials in environment
# Looks like these do get erased each session
Sys.setenv(
  "AWS_ACCESS_KEY_ID" = "TEST",
  "AWS_SECRET_ACCESS_KEY" = "test",
  "AWS_DEFAULT_REGION" = "us-west-2"
)
Sys.getenv()

# Remove credentials
Sys.unsetenv(
  c(
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "AWS_DEFAULT_REGION"
  )
)
Sys.getenv()



# 01. Save credentials ----------------------------------------------------
# Same as for CodeCommit
Sys.setenv(
  "AWS_ACCESS_KEY_ID" = "",      # fill in access key ID
  "AWS_SECRET_ACCESS_KEY" = "",  # fill in access key
  "AWS_DEFAULT_REGION" = "us-west-2"
)

# Test access
bucketlist()



# 02. Access data ---------------------------------------------------------
contents <- get_bucket(bucket = "chelan.projects.fourpeaksenv.com")

# One row for each object, regardless of folder hierarchy
info <- contents %>%
  data.table::rbindlist() %>%
  tibble()

filter(info, str_detect(Key, "master_df_study")) # odd that there are duplicates
arrange(info, Size) %>% # pick a small file to look at
  print(n = 20)
small <- filter(info, Size < 142 & Size > 0) %>%
  slice(n = 1) %>%
  pull(Key)

# Confusing formatting
get_object(
  object = small,
  show_progress = TRUE
)

# Get a file from in the bucket using the Key
# get_object("s3://myexamplebucket/mtcars", show_progress = TRUE)
jj <- get_object(
  object = "at_2021/at_data/cleaned_combined/master_df_study_events.csv",
  bucket = "chelan.projects.fourpeaksenv.com",
  show_progress = TRUE
)


# Unlike a database that I could query, the only option with S3 is to save the
# file locally using save_object. 
