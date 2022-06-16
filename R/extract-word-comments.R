library("tidyverse")
library("docxtractr")

doc <- read_docx("C:/Users/ElizabethNg/Downloads/Cushman 2021 Annual Report_TPU Comments.docx")

out <- doc |>
  docx_extract_all_cmnts()

write_csv(out, "cushman-comments.csv")
