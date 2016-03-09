setwd("~/Repositories/zika-flirt-val")
library(car)
uscodes <- read.csv("~/Repositories/zika-flirt-val/data/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodesraw, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumcurr <- read.csv("~/Repositories/zika-flirt-val/data/sim_all_sum_curr.csv", header = TRUE, sep = ",")
simsumcurr <- data.frame(lapply(simsumcurr, as.character), stringsAsFactors=FALSE)

#subset data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
library(plyr)
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimcurr<- inner_join(simsumcurr, uscodessub)

#------If Metro------

#recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA
usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'JFK'='JFK/EWR/LGA'")
usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'EWR'='JFK/EWR/LGA'")
usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'LGA'='JFK/EWR/LGA'")

usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'IAD'='IAD/DCA'")
usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'DCA'='IAD/DCA'")

usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'FLL'='MIA/FLL'")
usonlysimcurr$Code <- recode(usonlysimcurr$Code, " 'MIA'='MIA/FLL'")

usonlysimcurr$sum_occur<- as.numeric(usonlysimcurr$sum_occur)

#airport agg
#ONLY USE RECODE COMMAND FOR AIRPORTS
#usonlysim$State <-recode(usonlysim$State, " 'NJ'= 'NY'")
usonlysimcurr_agg<-aggregate(sum_occur ~ Code, data=usonlysimcurr, sum)

#write metro area agg to csv
write.csv(usonlysimcurr_agg, file="~/Desktop/us_only_sim_cur.csv")

#----if State------

usonlysimcurr$sum_occur<- as.numeric(usonlysimcurr$sum_occur)

#state agg
usonlysimcurr_agg_state<- aggregate(sum_occur ~ State, data=usonlysimcurr, sum)


#write state ag to csv
write.csv(usonlysimcurr_agg_state, file="~/Desktop/us_only_sim_curr_state.csv")
