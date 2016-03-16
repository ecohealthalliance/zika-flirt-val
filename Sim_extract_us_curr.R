
library(dplyr)
library(car)
uscodes <- read.csv("rawdata/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumcurr <- read.csv("rawdata/sim_all_sum_curr_scale.csv", header = TRUE, sep = ",")
simsumcurr <- data.frame(lapply(simsumcurr, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
colnames(uscodessub)[1]<- "code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimcurr<- inner_join(simsumcurr, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlysimcurr$seats<- as.numeric(usonlysimcurr$seats)
usonlysimcurr_agg_state<- aggregate(seats ~ State, data=usonlysimcurr, sum)

#----------

#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimcurr_met<-usonlysimcurr[,c(1,2)]  

usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'JFK'='JFK/EWR/LGA/HPN'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'EWR'='JFK/EWR/LGA/HPN'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'LGA'='JFK/EWR/LGA/HPN'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'HPN'='JFK/EWR/LGA/HPN'")

usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'IAD'='IAD/DCA/BWI'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'DCA'='IAD/DCA/BWI'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'BWI'='IAD/DCA/BWI'")

usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'FLL'='MIA/FLL'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'MIA'='MIA/FLL'")

usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'SJC'='SJC/OAK/SFO'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'OAK'='SJC/OAK/SFO'")
usonlysimcurr_met$code <- recode(usonlysimcurr_met$code, " 'SFO'='SJC/OAK/SFO'")

#airport agg
usonlysimcurr_met$seats<- as.numeric(usonlysimcurr_met$seats)
usonlysimcurr_met_agg<-aggregate(seats ~ code, data=usonlysimcurr_met, sum)


