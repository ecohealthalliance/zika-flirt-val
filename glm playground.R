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

