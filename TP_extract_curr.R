library(dplyr)
library(car)

uscodes <- read.csv("rawdata/us_codes_raw.csv", as.is = TRUE)

# Import and subset aggregated simulation data
tcurr <- read.csv("rawdata/flirt_output/TP_all_global_curr_2.csv", as.is = TRUE)
tcurr <-tcurr[,c(6,12)]

colnames(tcurr)<- c("code", "seats")

tcurr_agg<-aggregate(seats ~ code, data = tcurr, sum)

# Subset US airport code data
uscodessub <- uscodes[,c(1,4)]

# Rename columns of uscodes sub
colnames(uscodessub) <- tolower(names(uscodessub))

# Inner join by code to compare US aiports list and extract US simulation results only
usonlytcurr <- inner_join(tcurr, uscodessub)

#---------

# State aggregate.
usonlytcurr_agg_state <- aggregate(seats ~ state, data = usonlytcurr, sum)


#----------

# For metro aggregate recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlytcurr_met <- usonlytcurr[,c(1,2)]

usonlytcurr_met$code[usonlytcurr_met$code %in% c("JFK", "EWR", "LGA")] <- "JFK/EWR/LGA"
usonlytcurr_met$code[usonlytcurr_met$code %in% c("IAD", "DCA", "BWI")] <- "IAD/DCA/BWI"
usonlytcurr_met$code[usonlytcurr_met$code %in% c("MIA", "FLL")] <- "MIA/FLL"
usonlytcurr_met$code[usonlytcurr_met$code %in% c("SJC", "OAK", "SFO")] <- "SJC/OAK/SFO"

#airport agg
usonlytcurr_met$seats<- as.numeric(usonlytcurr_met$seats)
usonlytcurr_met_agg<-aggregate(seats ~ code, data=usonlytcurr_met, sum)

