library(dplyr)
library(car)

uscodes <- read.csv("rawdata/us_codes_raw.csv", as.is = TRUE)

# Import and subset aggregated simulation data
tfut <- read.csv("rawdata/flirt_output/TP_all_global_fut.csv", as.is = TRUE)
tfut <-tfut[,c(6,12)]

colnames(tfut)<- c("code", "seats")

tfut$seats<- 8.72*tfut$seats

tppast_agg<-aggregate(seats ~ code, data = tfut, sum)

# Subset US airport code data
uscodessub <- uscodes[,c(1,4)]

# Rename columns of uscodes sub
colnames(uscodessub) <- tolower(names(uscodessub))

# Inner join by code to compare US aiports list and extract US simulation results only
usonlytfut <- inner_join(tfut, uscodessub)

#---------

# State aggregate.
usonlytfut_agg_state <- aggregate(seats ~ state, data = usonlytfut, sum)


#----------

# For metro aggregate recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlytfut_met <- usonlytfut[,c(1,2)]

usonlytfut_met$code[usonlytfut_met$code %in% c("JFK", "EWR", "LGA", "HPN")] <- "JFK/EWR/LGA/HPN"
usonlytfut_met$code[usonlytfut_met$code %in% c("IAD", "DCA", "BWI")] <- "IAD/DCA/BWI"
usonlytfut_met$code[usonlytfut_met$code %in% c("MIA", "FLL")] <- "MIA/FLL"
usonlytfut_met$code[usonlytfut_met$code %in% c("SJC", "OAK", "SFO")] <- "SJC/OAK/SFO"
usonlytfut_met$code[usonlytfut_met$code %in% c("ATL", "BHM")] <- "HSV/BHM"
usonlytfut_met$code[usonlytfut_met$code %in% c("MGM", "CSG")] <- "MGM/CSG"
usonlytfut_met$code[usonlytfut_met$code %in% c("CMH", "LCK")] <- "CMH/LCK"

#airport agg
usonlytfut_met$seats<- as.numeric(usonlytfut_met$seats)
usonlytfut_met_agg<-aggregate(seats ~ code, data=usonlytfut_met, sum)

write.csv(usonlytfut_met_agg, file = "data/TP_region_fut.csv", row.names = FALSE)
write.csv(usonlytfut_agg_state, file = "data/TP_state_fut.csv", row.names = FALSE)

