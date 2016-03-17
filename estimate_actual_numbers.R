library(dplyr)
library(magrittr)
options(stringsAsFactors = FALSE)

# We simulated 100000 passengers
sim_total <- 100000

# The total output (yearly?) for these airports in FLIRT, in terms of seats
# scheduled, is as follows.
flirt <- c(GRU = 669567,
           BOG = 424750,
           CCS = 590231,
           SAL = 395739,
           SAP = 99709)
flirt_total <- sum(flirt)

# The total real-life yearly output for these airports, according to FAA
# numbers sourced from Wikipedia by Karissa, is as follows.
real <- c(GRU = 38985000,
          BOG = 30566473,
          CCS = 20942546,
          SAL = 3113740,
          SAP = 772504)
real_total <- sum(real)

# These are the scale factors, which indicate how many FLIRT output or real
# passengers each simulated passenger represents. Assuming (1) that we've
# basically reached Central Limit Theorem with 100000 passengers such that
# randomness isn't affecting the distribution in a significant way, and (2)
# that the schedules in FLIRT are an accurate representation of all schedules,
# we should be able to multiply our FLIRT results by these numbers to see how
# many actual passengers the risk commutes.

# For a second, I was multiplying to factor out the 61 days (8.5 weeks) that the simulation was run for, but the 100000 is actually unitless vis-a-vis time. It is simply a measure of probability.

flirt_factor = (flirt_total / sim_total)
real_factor = (real_total / sim_total)

# Once we multiply the "seats" results in the tables by this factor, we *should* have converted the rate of the simulation numbers to "passengers per year". From there, it's simple to scale them to the time period of interest.

files <- list.files("data", pattern = "past|curr", full.names = TRUE)

SIM_state_curr <- read.csv(files[[3]])

# This model uses the 100000 seats.
m1 <- glm(case_count ~ seats, data = SIM_state_curr, family = gaussian())
summary(m1)


SIM_state_curr %<>%
  mutate(real_seats_est = seats * real_factor * (61 / 365),
         real_100000 = real_seats_est / 100000)

# This model is in terms of "estimated actual passengers"
m2 <- glm(case_count ~ real_seats_est, data = SIM_state_curr, family = gaussian())
summary(m2)

# This one is in terms of "per 100,000 passengers"
m3 <- glm(case_count ~ real_100000, data = SIM_state_curr, family = gaussian())
summary(m3)
# The interpretation is "For every 100,000 passengers, there are 5.67 (± 0.27) Zika cases imported". BOOM!