library(purrr)
library(dplyr)

options(stringsAsFactors = FALSE)

sink("output/glms-gaussian-standardized.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "past|curr", full.names = TRUE)
cat("\n")
cat("\n")
list.files("data", pattern = "past|curr", full.names = TRUE) %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ seats, data = .x, family = gaussian())) %>%
  map(summary)
sink()

# This one isn't running right now

# sink("output/glms-poisson.txt")
# cat("Tests run in the following order:\n\n")
# list.files("data", pattern = "past|curr", full.names = TRUE)
# cat("\n")
# cat("\n")
# list.files("data", pattern = "past|curr", full.names = TRUE) %>%
#   map(read.csv) %>%
#   map(~ mutate(.x, seats = seats / sd(seats))) %>%
#   map(~ glm(case_count ~ seats, data = .x, family = poisson(link = "identity"))) %>%
#   map(summary)
# sink()
