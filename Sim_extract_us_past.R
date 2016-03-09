#####NEED TO FIX EWR/JFK/LGA and ATL being counted twice...

setwd("~/Repositories/zika-flirt-val")

library(car)
uscodes <- read.csv("~/Repositories/zika-flirt-val/data/us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodes, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsumpast <- read.csv("~/Repositories/zika-flirt-val/data/sim_all_sum_past.csv", header = TRUE, sep = ",")
simsumpast <- data.frame(lapply(simsumpast, as.character), stringsAsFactors=FALSE)

#subset Us airport code data
uscodessub<- uscodes[,c(1,4)]
uscodessub<-data.frame(uscodessub)

#rename columns of uscodes sub
library(plyr)
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimpast<- inner_join(simsumpast, uscodessub)
---------
#state aggregate. must turnt o numeric first
usonlysimpast$sum_occur<- as.numeric(usonlysimpast$sum_occur)
usonlysimpast_agg_state<- aggregate(sum_occur ~ State, data=usonlysimpast, sum)

#write state ag to csv
#write.csv(usonlysimpast_agg_state, file="~/Desktop/us_only_sim_past_state.csv")

----------
  
#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA
usonlysimpast$Code <- recode(usonlysimpast$Code, " 'JFK'='JFK/EWR/LGA'")
usonlysimpast$Code <- recode(usonlysimpast$Code, " 'EWR'='JFK/EWR/LGA'")
usonlysimpast$Code <- recode(usonlysimpast$Code, " 'LGA'='JFK/EWR/LGA'")

usonlysimpast$Code <- recode(usonlysimpast$Code, " 'IAD'='IAD/DCA'")
usonlysimpast$Code <- recode(usonlysimpast$Code, " 'DCA'='IAD/DCA'")

usonlysimpast$Code <- recode(usonlysimpast$Code, " 'FLL'='MIA/FLL'")
usonlysimpast$Code <- recode(usonlysimpast$Code, " 'MIA'='MIA/FLL'")

#airport agg
usonlysimpast$sum_occur<- as.numeric(usonlysimpast$sum_occur)
usonlysimpast_agg<-aggregate(sum_occur ~ Code, data=usonlysimpast, sum)

#write metro area agg to csv
#write.csv(usonlysimpast_agg, file="~/Desktop/us_only_sim_past.csv")
