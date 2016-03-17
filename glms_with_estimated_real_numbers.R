library(dplyr)
library(purrr)
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

# These numbers don't 100% match up with the FLIRT numbers.
qplot(real, flirt)

# In addition, the real numbers are for *all passengers*, not just outgoing
# passengers. That would include incoming, outgoing, and layovers. However,
# layovers are probably a smallish fraction: We know that, in the domestic US,
# two-leg flights constitute like a third or less of trips, and only 1/3 of
# the airports they are at are layovers, so really 1/9 plus a bit of
# passengers in that scenario are laying over. So, we're going to divide the
# "real" numbers in half to get the actual numbers.
real_out <- real / 2
real_total <- sum(real_out)

# These are the scale factors, which indicate how many FLIRT output or real
# passengers each simulated passenger represents. Assuming (1) that we've
# basically reached Central Limit Theorem with 100000 passengers such that
# randomness isn't affecting the distribution in a significant way, and (2)
# that the schedules in FLIRT are an accurate representation of all schedules,
# we should be able to multiply our FLIRT results by these numbers to see how
# many actual passengers the risk commutes.

# For a second, I was multiplying to factor out the 61 days (8.5 weeks) that
# the simulation was run for, but the 100000 is actually unitless vis-a-vis
# time. It is simply a measure of probability.

flirt_factor = (flirt_total / sim_total)
real_factor = (real_total / sim_total)

# Once we multiply the "seats" results in the tables by this factor, we
# *should* have converted the rate of the simulation numbers to "passengers
# per year". From there, it's simple to scale them to the time period of
# interest.

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
# The interpretation is "For every 100,000 passengers, there are 5.67 (± 0.27)
# Zika cases imported". BOOM!



# --------------------------

# I'm going to run the same computation on SIM_region_curr.

SIM_region_curr <- read.csv(files[[1]])

# This model uses the 100000 seats.
m4 <- glm(case_count ~ seats, data = SIM_region_curr, family = gaussian())
summary(m4)


SIM_region_curr %<>%
  mutate(real_seats_est = seats * real_factor * (61 / 365),
         real_100000 = real_seats_est / 100000)

# This model is in terms of "estimated actual passengers"
m5 <- glm(case_count ~ real_seats_est, data = SIM_region_curr, family = gaussian())
summary(m5)

# This one is in terms of "per 100,000 passengers"
m6 <- glm(case_count ~ real_100000, data = SIM_region_curr, family = gaussian())
summary(m6)



# --------------------------

# This is the workflow to run the model, run on the "Per 100000 passengers in
# that time period."

# This only really makes sense for Simulation in the current methodology,
# because it's the one which is pegged to 100000 people.

files %<>%
  grep("(?=.*SIM)(?=.*past|.*curr)", ., perl = TRUE, value = TRUE)

sink("output/glms-gaussian-100000.txt")
cat("Tests run in the following order:\n\n")
files
cat("\n")
cat("\n")
files %>%
  map(read.csv) %>%
  map(~ mutate(.x, real_seats_est = seats * real_factor * (61 / 365),
         real_100000 = real_seats_est / 100000)) %>%
  map(~ glm(case_count ~ real_100000, data = .x, family = gaussian())) %>%
  map(summary)
sink()