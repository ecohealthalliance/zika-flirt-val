library(dplyr)
library(magrittr)
library(lubridate)
library(ggplot2)
options(stringsAsFactors = FALSE)

flights <- read.csv("rawdata/flightCounts.csv") %>%
  mutate(date = parse_date_time(date, orders = "ymdhms"),
         count_norm = count / max(count) * 100) %>%
  filter(count_norm > 1)


qplot(date, count_norm, data = flights, geom = "line")

# It looks to me that the count of flight records drops below 50% in late 2016, and is at around 25% in mid 2017, and drops down below 10% in 2018.

flights[flights$count_norm < 50, ]
# The date where it drops below 50% is October 29th, 2016. 

flights[year(flights$date) == 2017, ]
# The first date the count of flights drops below 25% is March 26th, 2017. It overs around there for most of that year. The last date  it's at or above 25% is September 25th, 2017.

flights[which.max(flights$count), ]
# The maximum number of flight schedules at one time in the dataset is 667016. This occurs on February 7th, 2016.
#           date  count count_norm
# 496 2016-02-07 667016        100