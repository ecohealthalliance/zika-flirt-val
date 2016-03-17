library(purrr)
library(dplyr)

options(stringsAsFactors = FALSE)

sink("output/glms-gaussian.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "state|region", full.names = TRUE)
cat("\n")
cat("\n")
list.files("data", pattern = "state|region", full.names = TRUE) %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ seats, data = .x, family = gaussian())) %>%
  map(summary)
sink()


sink("output/glms-poisson.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "state|region", full.names = TRUE)
cat("\n")
cat("\n")
list.files("data", pattern = "state|region", full.names = TRUE) %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ seats, data = .x, family = poisson(link = "identity"))) %>%
  map(summary)
sink()