# Accessing MS Access Database from R
# https://www.roelpeters.be/solved-importing-microsoft-access-files-accdb-mdb-in-r/
# Must run in 32-bit version of R

# install.packages("RODBC")
library("RODBC")
library("tidyverse")

fp <- "C:/Users/ElizabethNg/Downloads/FCMRedbandTroutSpawningPreferenceAreas.mdb"

# con <- odbcConnectAccess2007(fp)
con <- odbcConnectAccess(fp)

# Get the list of tables
tabs <- sqlTables(con) %>%
  tibble() %>%
  filter(str_detect(TABLE_NAME, "PreferenceAreasVisit\\d{2}$"))

sqlFetch(con, tabs$TABLE_NAME[1])
