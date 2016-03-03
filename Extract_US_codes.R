
uscodesraw <- read.csv("us_codes_raw.csv", header = TRUE, sep = ",")

#turn data frame to character data frame
uscodes <- data.frame(lapply(uscodesraw, as.character), stringsAsFactors=FALSE)

#import aggregated simulation data
simsum <- read.csv("sim_sum.csv", header = TRUE, sep = ",")
simsum <- data.frame(lapply(simsum, as.character), stringsAsFactors=FALSE)

#subset data
codessub<- uscodes[,c(1,4)]
new<-data.frame(codessub)

#add a new column0 NOT NECESSARY
#new$newcolumn<-NA

#rename new
library(plyr)
colnames(new)[1]<- "Code"

#inner join (can also use semi?? not sure) by code to compare US aiports list and extract US simulation results only
require(dplyr)
us_onlysim<- inner_join(simsum, new)

#write to csv
write.csv(us_onlysim, file="US_Only_Sim_inner.csv")
