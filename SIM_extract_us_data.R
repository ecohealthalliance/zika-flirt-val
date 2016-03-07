setwd("~/Repositories/zika-flirt-val")
uscodesraw <- read.csv("~/Repositories/zika-flirt-val/data/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodesraw, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsum <- read.csv("~/Repositories/zika-flirt-val/data/sim_sum.csv", header = TRUE, sep = ",")
simsum <- data.frame(lapply(simsum, as.character), stringsAsFactors=FALSE)

#subset data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
library(plyr)
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysim<- inner_join(simsum, uscodessub)


#recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA
usonlysim$Code <- recode(usonlysim$Code, " 'JFK'='JFK/EWR/LGA'")
usonlysim$Code <- recode(usonlysim$Code, " 'EWR'='JFK/EWR/LGA'")
usonlysim$Code <- recode(usonlysim$Code, " 'LGA'='JFK/EWR/LGA'")

usonlysim$Code <- recode(usonlysim$Code, " 'IAD'='IAD/DCA'")
usonlysim$Code <- recode(usonlysim$Code, " 'DCA'='IAD/DCA'")

usonlysim$Code <- recode(usonlysim$Code, " 'FLL'='MIA/FLL'")
usonlysim$Code <- recode(usonlysim$Code, " 'FLL'='MIA/FLL'")

usonlysim$sum_occur<- as.numeric(usonlysim$sum_occur)

#state agg
usonlysim_agg_state<- aggregate(sum_occur ~ State, data=usonlysim, sum)

#airport agg
usonlysim_agg<-aggregate(sum_occur ~ Code + State, data=usonlysim, sum)

#write metro area agg to csv
#write.csv(usonlysim_agg, file="~/Repositories/zika-flirt-val/data/us_only_sim.csv")

#write state ag to csv
#write.csv(usonlysim_agg_state, file="~/Repositories/zika-flirt-val/data/us_only_sim_state.csv")
