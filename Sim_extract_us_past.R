#####YOU HAVE TO RUN THIS IN CHUNKS FRO SOME REASON. UNARY OPERATOR ERROR WHEN SOURCES ALL AT ONCE?

setwd("~/Repositories/zika-flirt-val")
library(dplyr)
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
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysimpast<- inner_join(simsumpast, uscodessub)
#---------
#state aggregate. must turnt o numeric first
usonlysimpast$sum_occur<- as.numeric(usonlysimpast$sum_occur)
usonlysimpast_agg_state<- aggregate(sum_occur ~ State, data=usonlysimpast, sum)

#write state ag to csv
#write.csv(usonlysimpast_agg_state, file="~/Desktop/us_only_sim_past_state.csv")

#----------
  
#for metro aggregate....recode metro areas IAD/DCA, MIA/FLL and JFK/EWR/LGA

usonlysimpast_met<-usonlysimpast[,c(1,2)]  
  
usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'JFK'='JFK/EWR/LGA'")
usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'EWR'='JFK/EWR/LGA'")
usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'LGA'='JFK/EWR/LGA'")

usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'IAD'='IAD/DCA'")
usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'DCA'='IAD/DCA'")

usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'FLL'='MIA/FLL'")
usonlysimpast_met$Code <- recode(usonlysimpast_met$Code, " 'MIA'='MIA/FLL'")

#airport agg
usonlysimpast_met$sum_occur<- as.numeric(usonlysimpast_met$sum_occur)
usonlysimpast_met_agg<-aggregate(sum_occur ~ Code, data=usonlysimpast_met, sum)

#write metro area agg to csv
#write.csv(usonlysimpast_met_agg, file="~/Desktop/us_only_sim_past.csv")
