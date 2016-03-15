library(Kendall)
library(purrr)
library(dplyr)

options(stringsAsFactors = FALSE)

sink("output/Kendall.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "state|region", full.names = TRUE)
cat("\n")
list.files("data", pattern = "state|region", full.names = TRUE) %>%
  map(read.csv) %>%
  map(~ Kendall(x = .x[, 2], y = .x[, 3]))
sink()