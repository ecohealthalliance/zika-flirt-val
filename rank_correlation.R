library(Kendall)
library(Hmisc)
library(vcdExtra)
library(dplyr)
library(magrittr)
library(readr)
library(purrr)


state <- read.csv("data/state_past.csv")

cor.test(state$sum_occur, state$case_count, method = "spearman") 
cor.test(state$sum_occur, state$case_count, method = "kendall") 
Kendall(state$sum_occur, state$case_count)

rcorr.cens(state$sum_occur, state$case_count, outx = TRUE)
GKgamma(state[, 2:3])


region <- read.csv("data/region_past.csv")

cor.test(region$sum_occur, region$case_count, method = "spearman") 
cor.test(region$sum_occur, region$case_count, method = "kendall") 
Kendall(region$sum_occur, region$case_count)

rcorr.cens(region$sum_occur, region$case_count, outx = TRUE)
GKgamma(region[, 2:3])

region_sub <- region %>%
  filter(case_count != 0)

Kendall(region_sub$sum_occur, region_sub$case_count)



sink("output/Kendall.txt")
cat("Tests run in the following order:\n\n")
list.files("data", pattern = "state|region", full.names = TRUE)
cat("\n")
list.files("data", pattern = "state|region", full.names = TRUE) %>%
  map(read_csv) %>%
  map(~ Kendall(x = .x$sum_occur, y = .x$case_count))
sink()