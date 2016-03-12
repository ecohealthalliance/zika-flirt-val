library(Kendall)
library(readr)
library(purrr)

sink("output/Kendall.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "state|region", full.names = TRUE)
cat("\n")
list.files("data", pattern = "state|region", full.names = TRUE) %>%
  map(read_csv) %>%
  map(~ Kendall(x = .x$sum_occur, y = .x$case_count))
sink()