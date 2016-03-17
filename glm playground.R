library(ggplot2)
library(dplyr)

x <- 1:100 + (rnorm(100) * 5)
y <- 1:100 + (rnorm(100) * 5) * 2

x <- rpois(n = 1000, lambda = 10)
y <- pmax(round((x + rnorm(1000, sd = 5)) * 0.5), 0)

qplot(x, y, geom = "jitter")
qplot(log(x), log(y), geom = "jitter")

glm(y ~ x, family = poisson()) %>% summary()
glm(y ~ x, family = gaussian()) %>% summary()







# sink("output/glms-poisson.txt")
# cat("Tests run in the following order:\n\n")
# list.files("data", pattern = "state|region", full.names = TRUE)
# cat("\n")
# cat("\n")
# list.files("data", pattern = "state|region", full.names = TRUE) %>%
#   map(read.csv) %>%
#   map(~ mutate(.x, seats = seats / (2 * sd(seats)))) %>%
#   map(~ glm(case_count ~ seats, data = .x, family = poisson())) %>%
#   map(summary)
# sink()


# sink("output/glms-gaussian.txt")
# cat("Tests run in the following order:\n\n")
# list.files("data", pattern = "state|region", full.names = TRUE)
# cat("\n")
# cat("\n")
# list.files("data", pattern = "state|region", full.names = TRUE) %>%
#   map(read.csv) %>%
#   map(~ mutate(.x, seats = seats / (2 * sd(seats)))) %>%
#   map(~ glm(case_count ~ seats, data = .x, family = gaussian())) %>%
#   map(summary)
# sink()



m1 <- list.files("data", pattern = "state|region", full.names = TRUE)[c(1, 3)] %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ seats, data = .x, family = gaussian()))

m2 <- list.files("data", pattern = "state|region", full.names = TRUE)[c(1, 3)] %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ seats, data = .x, family = poisson()))

m3 <- list.files("data", pattern = "state|region", full.names = TRUE)[c(1, 3)] %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ seats, data = .x, family = poisson(link = "identity")))

m4 <- list.files("data", pattern = "state|region", full.names = TRUE)[c(1, 3)] %>%
  map(read.csv) %>%
  map(~ mutate(.x, seats = seats / sd(seats))) %>%
  map(~ glm(case_count ~ log(seats), data = .x, family = poisson()))


csvs <- m1 <- list.files("data", pattern = "state|region", full.names = TRUE)[c(1, 3)] %>%
  map(read.csv)

region <- csvs[[1]]

reg.gaus <- glm(case_count ~ seats, data = region, family = gaussian())
reg.pois <- glm(case_count ~ seats, data = region, family = poisson())
reg.pois.id <- glm(case_count ~ seats, data = region, family = poisson(link = "identity"))

fortify(reg.gaus) %>%
  ggplot() +
  geom_point(aes(x = seats, y = case_count)) +
  geom_line(aes(x = seats, y = .fitted))

fortify(reg.pois) %>%
  ggplot() +
  geom_point(aes(x = seats, y = case_count)) +
  geom_line(aes(x = seats, y = .fitted))
# Uh, yeah, not Poisson.

fortify(reg.pois.id) %>%
  ggplot() +
  geom_point(aes(x = seats, y = case_count)) +
  geom_line(aes(x = seats, y = .fitted))




state <- csvs[[2]]

sta.gaus <- glm(case_count ~ seats, data = state, family = gaussian())
sta.pois <- glm(case_count ~ seats, data = state, family = poisson())
sta.pois.id <- glm(case_count ~ seats, data = state, family = poisson(link = "identity"))

fortify(sta.gaus) %>%
  ggplot() +
  geom_point(aes(x = seats, y = case_count)) +
  geom_line(aes(x = seats, y = .fitted))

fortify(sta.pois) %>%
  ggplot() +
  geom_point(aes(x = seats, y = case_count)) +
  geom_line(aes(x = seats, y = .fitted))
# Uh, yeah, not Poisson.

fortify(sta.pois.id) %>%
  ggplot() +
  geom_point(aes(x = seats, y = case_count)) +
  geom_line(aes(x = seats, y = .fitted))