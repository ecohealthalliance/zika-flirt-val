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

#add a new column NOT NECESSARY
#new$newcolumn<-NA

#rename columns of uscodes sub
library(plyr)
colnames(uscodessub)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
usonlysim<- inner_join(simsum, uscodessub)

#write to csv
write.csv(usonlysim, file="~/Repositories/zika-flirt-val/data/us_only_sim.csv")
