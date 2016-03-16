
library(dplyr)
library(car)
uscodes <- read.csv("rawdata/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumpast <- read.csv("rawdata/flirt_output/sim_all_sum_past_scale.csv", header = TRUE, sep = ",")
simsumpast <- data.frame(lapply(simsumpast, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
colnames(uscodessub)[1]<- "code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimpast<- inner_join(simsumpast, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlysimpast$seats<- as.numeric(usonlysimpast$seats)
usonlysimpast_agg_state<- aggregate(seats ~ State, data=usonlysimpast, sum)

#----------
  
#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimpast_met<-usonlysimpast[,c(1,2)]  
  
usonlysimpast_met$code[usonlysimpast_met$code %in% c("JFK", "EWR", "LGA", "HPN")] <- "JFK/EWR/LGA/HPN"
usonlysimpast_met$code[usonlysimpast_met$code %in% c("IAD", "DCA", "BWI")] <- "IAD/DCA/BWI"
usonlysimpast_met$code[usonlysimpast_met$code %in% c("MIA", "FLL")] <- "MIA/FLL"
usonlysimpast_met$code[usonlysimpast_met$code %in% c("SJC", "OAK", "SFO")] <- "SJC/OAK/SFO"
usonlysimpast_met$code[usonlysimpast_met$code %in% c("ATL", "BHM")] <- "HSV/BHM"
usonlysimpast_met$code[usonlysimpast_met$code %in% c("MGM", "CSG")] <- "MGM/CSG"
usonlysimpast_met$code[usonlysimpast_met$code %in% c("CMH", "LCK")] <- "CMH/LCK"


#airport agg
usonlysimpast_met$seats<- as.numeric(usonlysimpast_met$seats)
usonlysimpast_met_agg<-aggregate(seats ~ code, data=usonlysimpast_met, sum)


