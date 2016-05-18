library(jsonlite)
library(dplyr)
library(magrittr)
library(purrr)
library(lubridate)
library(ggplot2)


# Read in the flight counts JSON file.
flightCountsByAirport <- fromJSON("flightCountsByAirport.json")
flightCountsByAirport %<>%
  mutate(departureCount = ifelse(is.na(departureCount), 0, departureCount),
         arrivalCount = ifelse(is.na(arrivalCount), 0, arrivalCount),
         totalCount = departureCount + arrivalCount)

# Calculate the total number of flights.
globalSummary <- flightCountsByAirport %>%
  summarize(departureCount = sum(departureCount),
            arrivalCount = sum(arrivalCount),
            totalCount = sum(totalCount))

# Sum by country.
flightCountsByCountry <- flightCountsByAirport %>%
  group_by(countryName) %>%
  summarize(departureCount = sum(departureCount),
            arrivalCount = sum(arrivalCount),
            totalCount = sum(totalCount)) %>%
  arrange(desc(totalCount))

# Sum by region.
flightCountsByRegion <- flightCountsByAirport %>%
  group_by(globalRegion) %>%
  summarize(departureCount = sum(departureCount),
            arrivalCount = sum(arrivalCount),
            totalCount = sum(totalCount)) %>%
  arrange(desc(totalCount))


# Read in flightCountsByDay, save some plots.
flightCountsByDay <- fromJSON("flightCountsByDay.json") %>%
  mutate(date = as.POSIXct(date))

ggplot(flightCountsByDay, aes(date, count)) + geom_line() + ylim(0, 450000)
ggsave("flightCountsByDay.png", width = 6.5, height = 4.5)

flightCountsByDay %>%
  mutate(weekday = wday(date)) %>%
  group_by(weekday) %>%
  summarize(weekdayCount = sum(count)) %>%
  ggplot(., aes(weekday, weekdayCount)) + geom_bar(stat = "identity")
ggsave("flightCountsByWeekday.png", width = 6.5, height = 4.5)

totalFlightCount <- flightCountsByDay %>%
  summarize(total = sum(count))


# This line of code saves every object in memory to a CSV file.
walk2(map(ls(), get), paste0(ls(), ".csv"), write.csv, row.names = FALSE)