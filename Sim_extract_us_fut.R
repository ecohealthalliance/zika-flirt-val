
library(dplyr)
library(car)
uscodes <- read.csv("data/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumfut <- read.csv("data/sim_all_sum_past.csv", header = TRUE, sep = ",")
simsumfut <- data.frame(lapply(simsumfut, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimfut<- inner_join(simsumfut, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlysimfut$sum_occur<- as.numeric(usonlysimfut$sum_occur)
usonlysimfut_agg_state<- aggregate(sum_occur ~ State, data=usonlysimfut, sum)

#----------

#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimfut_met<-usonlysimfut[,c(1,2)]  

usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'JFK'='JFK/EWR/LGA/HPN'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'EWR'='JFK/EWR/LGA/HPN'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'LGA'='JFK/EWR/LGA/HPN'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'HPN'='JFK/EWR/LGA/HPN'")

usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'IAD'='IAD/DCA/BWI'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'DCA'='IAD/DCA/BWI'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'BWI'='IAD/DCA/BWI'")

usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'FLL'='MIA/FLL'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'MIA'='MIA/FLL'")

usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'SJC'='SJC/OAK/SFO'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'OAK'='SJC/OAK/SFO'")
usonlysimfut_met$Code <- recode(usonlysimfut_met$Code, " 'SFO'='SJC/OAK/SFO'")

#airport agg
usonlysimfut_met$sum_occur<- as.numeric(usonlysimfut_met$sum_occur)
usonlysimfut_met_agg<-aggregate(sum_occur ~ Code, data=usonlysimfut_met, sum)


