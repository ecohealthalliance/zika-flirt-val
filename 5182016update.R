library(dplyr)
library(car)

uscodes <- read.csv("rawdata/us_codes_raw.csv", as.is = TRUE)

# Import and subset aggregated simulation data
tpast <- read.csv("rawdata/flirt_output/dataupdate5182016/TP_global_fut_airp2.csv", as.is = TRUE)
tpast <-tpast[,c(6,12)]

colnames(tpast)<- c("code", "seats")

tppast_agg<-aggregate(seats ~ code, data = tpast, sum)

# Subset US airport code data
uscodessub <- uscodes[,c(1,4)]

# Rename columns of uscodes sub
colnames(uscodessub) <- tolower(names(uscodessub))

# Inner join by code to compare US aiports list and extract US simulation results only
usonlytpast <- inner_join(tpast, uscodessub)

#---------

# State aggregate.
usonlytpast_agg_state <- aggregate(seats ~ state, data = usonlytpast, sum)
write.csv(usonlytpast_agg_state, file="data/dataupdateresults5182016/TP_fut_update_state_airp2.csv")

#----------

# For metro aggregate recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlytpast_met <- usonlytpast[,c(1,2)]

usonlytpast_met$code[usonlytpast_met$code %in% c("JFK", "EWR", "LGA")] <- "JFK/EWR/LGA"
usonlytpast_met$code[usonlytpast_met$code %in% c("IAD", "DCA", "BWI")] <- "IAD/DCA/BWI"
usonlytpast_met$code[usonlytpast_met$code %in% c("MIA", "FLL")] <- "MIA/FLL"
usonlytpast_met$code[usonlytpast_met$code %in% c("SJC", "OAK", "SFO")] <- "SJC/OAK/SFO"

#airport agg
usonlytpast_met$seats<- as.numeric(usonlytpast_met$seats)
usonlytpast_met_agg<-aggregate(seats ~ code, data=usonlytpast_met, sum)

#--- writecsv


write.csv(usonlytpast_met_agg, file="data/dataupdateresults5182016/TP_fut_update_met_airp2.csv")


#-------


