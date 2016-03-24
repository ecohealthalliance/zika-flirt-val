
library(dplyr)
library(car)
uscodes <- read.csv("rawdata/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumfut <- read.csv("rawdata/flirt_output/sim_all_sum_fut_scale.csv", header = TRUE, sep = ",")
simsumfut <- data.frame(lapply(simsumfut, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
colnames(uscodessub)[1]<- "code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimfut<- inner_join(simsumfut, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlysimfut$seats<- as.numeric(usonlysimfut$seats)
usonlysimfut_agg_state<- aggregate(seats ~ State, data=usonlysimfut, sum)

#----------

#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimfut_met<-usonlysimfut[,c(1,2)]  

usonlysimfut_met$code[usonlysimfut_met$code %in% c("JFK", "EWR", "LGA")] <- "JFK/EWR/LGA"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("IAD", "DCA", "BWI")] <- "IAD/DCA/BWI"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("MIA", "FLL")] <- "MIA/FLL"
usonlysimfut_met$code[usonlysimfut_met$code %in% c("SJC", "OAK", "SFO")] <- "SJC/OAK/SFO"

#airport agg
usonlysimfut_met$seats<- as.numeric(usonlysimfut_met$seats)
usonlysimfut_met_agg<-aggregate(seats ~ code, data=usonlysimfut_met, sum)

write.csv(usonlysimfut_met_agg, file = "data/SIM_region_fut_2.csv", row.names = FALSE)
write.csv(usonlysimfut_agg_state, file = "data/SIM_state_fut_2.csv", row.names = FALSE)

