library(dplyr)
library(car)

uscodes <- read.csv("rawdata/us_codes_raw.csv", as.is = TRUE)

# Import aggregated simulation data
simsumfut <- read.csv("rawdata/sim_all_sum_fut_scale.csv", as.is = TRUE)

# Subset US airport code data
uscodessub <- uscodes[,c(1,4)]

# Rename columns of uscodes sub
colnames(uscodessub) <- tolower(names(uscodessub))

# Inner join by code to compare US aiports list and extract US simulation results only
usonlysimfut <- inner_join(simsumfut, uscodessub)

#---------

# State aggregate.
usonlysimfut_agg_state <- aggregate(seats ~ state, data = usonlysimfut, sum)

write.csv(usonlysimfut_agg_state, "data/TP_state_fut.csv")

#----------

# For metro aggregate recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimfut_met <- usonlysimfut[,c(1,2)]

usonlysimfut_met$code[usonlysimfut_met$code %in% c("JFK", "EWR", "LGA", "HPN")] <- "JFK/EWR/LGA/HPN"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("IAD", "DCA", "BWI")] <- "IAD/DCA/BWI"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("MIA", "FLL")] <- "MIA/FLL"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("SJC", "OAK", "SFO")] <- "SJC/OAK/SFO"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("ATL", "BHM")] <- "HSV/BHM"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("MGM", "CSG")] <- "MGM/CSG"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("CMH", "LCK")] <- "CMH/LCK"

#airport agg
usonlysimfut_met$seats<- as.numeric(usonlysimfut_met$seats)
usonlysimfut_met_agg<-aggregate(seats ~ code, data=usonlysimfut_met, sum)

write.csv(usonlysimfut_agg_state, "data/TP_region_fut.csv")
