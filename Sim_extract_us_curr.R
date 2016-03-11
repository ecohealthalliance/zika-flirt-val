
library(dplyr)
library(car)
uscodes <- read.csv("~/Repositories/zika-flirt-val/data/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumcurr <- read.csv("~/Repositories/zika-flirt-val/data/sim_all_sum_past.csv", header = TRUE, sep = ",")
simsumcurr <- data.frame(lapply(simsumcurr, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimcurr<- inner_join(simsumcurr, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlysimcurr$sum_occur<- as.numeric(usonlysimcurr$sum_occur)
usonlysimcurr_agg_state<- aggregate(sum_occur ~ State, data=usonlysimcurr, sum)

#----------

#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimcurr_met<-usonlysimcurr[,c(1,2)]  

usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'JFK'='JFK/EWR/LGA/HPN'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'EWR'='JFK/EWR/LGA/HPN'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'LGA'='JFK/EWR/LGA/HPN'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'HPN'='JFK/EWR/LGA/HPN'")

usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'IAD'='IAD/DCA/BWI'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'DCA'='IAD/DCA/BWI'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'BWI'='IAD/DCA/BWI'")

usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'FLL'='MIA/FLL'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'MIA'='MIA/FLL'")

usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'SJC'='SJC/OAK/SFO'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'OAK'='SJC/OAK/SFO'")
usonlysimcurr_met$Code <- recode(usonlysimcurr_met$Code, " 'SFO'='SJC/OAK/SFO'")

#airport agg
usonlysimcurr_met$sum_occur<- as.numeric(usonlysimcurr_met$sum_occur)
usonlysimcurr_met_agg<-aggregate(sum_occur ~ Code, data=usonlysimcurr_met, sum)


