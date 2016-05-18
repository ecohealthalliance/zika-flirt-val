options(stringsAsFactors = FALSE)

library(dplyr)
library(purrr)
library(ggplot2)


# Read in the CSVs.

files <- list.files(pattern = ".csv")
temp <- map(files, read.csv)
names(temp) <- make.names(gsub("*.csv$", "", files))
list2env(temp, globalenv())


# Join the state and airport tables by their respective keys.
current.airport <- left_join(current.airport.expanded,
                             current.airport.paper,
                             by = "code") %>%
  rename(expanded = seats.x,
         paper = seats.y)

current.state <- left_join(current.state.expanded,
                           current.state.paper,
                           by = "state") %>%
  rename(expanded = seats.x,
         paper = seats.y)


# Simple linear models to see what the correlation is.

lm.current.airport <- lm(expanded ~ paper, data = current.airport)
summary(lm.current.airport)
ggplot(current.airport, aes(x = paper, y = expanded)) + geom_point() + geom_smooth(method = "lm")

lm.current.state <- lm(expanded ~ paper, data = current.state)
summary(lm.current.state)
ggplot(current.state, aes(x = paper, y = expanded)) + geom_point() + geom_smooth(method = "lm")

# The p-values here indicate that adding in secondary airports does not siginficantly change the relative numbers of passengers from FLIRT's output.


# Running log-log models just in case.

lm.current.airport <- lm(log(expanded) ~ log(paper), data = current.airport)
summary(lm.current.airport)
ggplot(current.airport, aes(x = log(paper), y = log(expanded))) + geom_point() + geom_smooth(method = "lm")

lm.current.state <- lm(log(expanded) ~ log(paper), data = current.state)
summary(lm.current.state)
ggplot(current.state, aes(x = log(paper), y = log(expanded))) + geom_point() + geom_smooth(method = "lm")