# Download PITAGIS data using API call
# instructions: https://www.dataquest.io/blog/r-api-tutorial/
# PITAGIS API structure: https://api.ptagis.org/swagger/ui/index

library("httr")
library("tidyverse")
library("jsonlite")


# Get interrogation sites
res <- GET("https://api.ptagis.org:443/interrogationsites")

# listviewer::jsonedit(res, mode = "view")

data <- fromJSON(rawToChar(res$content))
names(data)

# More information
# https://cfss.uchicago.edu/notes/application-program-interface/

# REST = representational state transfer (query database using URL)
# HTTP methods/verbs
#   GET = fetch existig resource, url contailns all info needed by server
#   POST = create a new resource. usually carry data to define
#   PUT = update an existing resource
#   DELETE = delete an existing resource


# Try DART data
# DART PIT Tag Adult Returns Observation Detail Query Link based on User Selections
# Use the following URL for scripting calls to DART PIT Tag Adult Returns Observation Detail Query Results based on User Selections
link <- "http://www.cbr.washington.edu/dart/cs/php/rpt/pitall_obs_de.php?sc=1&queryName=pitadult_obs_de&stage=A&outputFormat=default&year=2020&proj=RIA%3ARock+Island+Dam+Adult+%28RIA%29+rkm+730&species=1&run=1&rear_type=W&span=no&startdate=1%2F1&enddate=12%2F31&syear=2020&eyear=2020&reltype=alpha&relloc=&summary=no"
dart <- GET(link)
dartdat <- rawToChar(dart$content)
content(dart, as = "text")
# html format is terribly ugly

# alternate approach?
# https://stackoverflow.com/questions/44320008/parse-html-data-using-r
page <- xml2::read_html(dart) 
page %>% 
  xml2::xml_structure()

