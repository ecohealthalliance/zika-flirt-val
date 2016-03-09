setwd("~/Repositories/zika-flirt-val")
library(car)
uscodes <- read.csv("~/Repositories/zika-flirt-val/data/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodesraw, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumfut <- read.csv("~/Repositories/zika-flirt-val/data/sim_all_sum_fut.csv", header = TRUE, sep = ",")
simsumfut <- data.frame(lapply(simsumfut, as.character), stringsAsFactors=FALSE)

#subset data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
library(plyr)
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimfut<- inner_join(simsumfut, uscodessub)

#------If Metro------

#recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA
usonlysimfut$Code <- recode(usonlysimfut$Code, " 'JFK'='JFK/EWR/LGA'")
usonlysimfut$Code <- recode(usonlysimfut$Code, " 'EWR'='JFK/EWR/LGA'")
usonlysimfut$Code <- recode(usonlysimfut$Code, " 'LGA'='JFK/EWR/LGA'")

usonlysimfut$Code <- recode(usonlysimfut$Code, " 'IAD'='IAD/DCA'")
usonlysimfut$Code <- recode(usonlysimfut$Code, " 'DCA'='IAD/DCA'")

usonlysimfut$Code <- recode(usonlysimfut$Code, " 'FLL'='MIA/FLL'")
usonlysimfut$Code <- recode(usonlysimfut$Code, " 'MIA'='MIA/FLL'")

usonlysimfut$sum_occur<- as.numeric(usonlysimfut$sum_occur)

#airport agg
#ONLY USE RECODE COMMAND FOR AIRPORTS
#usonlysim$State <-recode(usonlysim$State, " 'NJ'= 'NY'")
usonlysimfut_agg<-aggregate(sum_occur ~ Code, data=usonlysimfut, sum)

write metro area agg to csv
write.csv(usonlysimfut_agg, file="~/Desktop/us_only_sim_fut.csv")

#----if State------

usonlysimfut$sum_occur<- as.numeric(usonlysimfut$sum_occur)

#state agg
usonlysim_agg_state<- aggregate(sum_occur ~ State, data=usonlysimfut, sum)


#write state ag to csv
write.csv(usonlysim_agg_state, file="~/Desktop/us_only_sim_state.csv")
