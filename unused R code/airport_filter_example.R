library(dplyr)
library(magrittr)

options(stringsAsFactors = FALSE)

uscodes <- read.csv("data/us_codes_raw.csv")
simsumcurr <- read.csv("data/sim_all_sum_curr.csv")

simsumcurr %<>%
  filter(Code %in% uscodes$Code)