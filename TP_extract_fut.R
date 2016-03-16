#Start with Global Aggregated list from all 5 origin airports. I started with a list that was already more edited  in excel than the past list so slightly less code

library(dplyr)
library(magrittr)
library(car)

TP_global <- read.csv("rawdata/TP_all_global_fut.csv", header = TRUE, sep = ",", stringsAsFactors=FALSE) 

TP_global<-  TP_global[,c(6,12)]

colnames(TP_global)<- c("code", "seats")

TP_global$seats<- 11.86*TP_global$seats

TP_global_agg<-aggregate(seats ~ code, data = TP_global, sum)

#-------

uscodes <- read.csv("rawdata/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
colnames(uscodessub)[1]<- "code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlytpfut<- inner_join(TP_global, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlytpfut$seats<- as.numeric(usonlytpfut$seats)
usonlytpfut_agg_state<- aggregate(seats~ State, data=usonlytpfut, sum)

write.csv(usonlytpfut_agg_state, file = "data/TP_state_rank_fut.csv", row.names = FALSE)

#----Metro Area ranking
usonlytpfut_met<-usonlytpfut[,c(1,2)]  

usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'JFK'='JFK/EWR/LGA/HPN'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'EWR'='JFK/EWR/LGA/HPN'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'LGA'='JFK/EWR/LGA/HPN'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'HPN'='JFK/EWR/LGA/HPN'")

usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'IAD'='IAD/DCA/BWI'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'DCA'='IAD/DCA/BWI'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'BWI'='IAD/DCA/BWI'")

usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'FLL'='MIA/FLL'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'MIA'='MIA/FLL'")

usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'SJC'='SJC/OAK/SFO'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'OAK'='SJC/OAK/SFO'")
usonlytpfut_met$code <- recode(usonlytpfut_met$code, " 'SFO'='SJC/OAK/SFO'")

#airport agg
usonlytpfut_met$seats<- as.numeric(usonlytpfut_met$seats)
usonlytpfut_met_agg<-aggregate(seats ~ code, data=usonlytpfut_met, sum)

write.csv(usonlytpfut_met_agg, file = "data/TP_region_rank_fut.csv", row.names = FALSE)

