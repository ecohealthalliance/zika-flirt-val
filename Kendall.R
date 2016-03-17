library(Kendall)
library(purrr)
library(dplyr)

options(stringsAsFactors = FALSE)

sink("output/kendall.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "past|curr", full.names = TRUE)
cat("\n")
list.files("data", pattern = "past|curr", full.names = TRUE) %>%
  map(read.csv) %>%
  map(~ Kendall(x = .x[["seats"]], y = .x[["case_count"]]))
sink()