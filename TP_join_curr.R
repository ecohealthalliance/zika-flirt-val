#Start with Global Aggregated list from all 5 origin airports. I started with a list that was already more edited  in excel than the past list so slightly less code

library(dplyr)
library(magrittr)
library(car)

TP_curr <- read.csv("data/TP_all_global_curr.csv", header = TRUE, sep = ",", stringsAsFactors=FALSE)


#state aggregate. must turnt o numeric first
TP_curr_state<- TP_curr[,c(2,3)]
TP_curr_state_agg<- aggregate(Total.Seats ~ Destination.State, data=TP_curr_state, sum)
colnames(TP_curr_state_agg)[1]<- "State"

#recode
TP_curr$Destination <- recode(TP_curr$Destination, " 'JFK'='JFK/EWR/LGA'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'EWR'='JFK/EWR/LGA'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'LGA'='JFK/EWR/LGA'")

TP_curr$Destination <- recode(TP_curr$Destination, " 'MIA'='MIA/FLL'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'FLL'='MIA/FLL'")

TP_curr$Destination <- recode(TP_curr$Destination, " 'IAD'='IAD/DCA/BWI'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'DCA'='IAD/DCA/BWI'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'BWI'='IAD/DCA/BWI'")

TP_curr$Destination <- recode(TP_curr$Destination, " 'SJC'='SJC/OAK/SFO'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'OAK'='SJC/OAK/SFO'")
TP_curr$Destination <- recode(TP_curr$Destination, " 'SFO'='SJC/OAK/SFO'")

#airport agg
TP_curr_agg<-aggregate(Total.Seats ~ Destination, data=TP_curr, sum)
colnames(TP_curr_agg)[1]<- "Code"

#--------
#read in latest zika case info and subset. newest case data should be renamed current_zika_cases and injested 
zikacasesraw <- read.csv("data/zika_cases_curr.csv", header = TRUE, sep = ",")
zikacases<-zikacasesraw[,c(8,10)]
zikacases<- data.frame(lapply(zikacases, as.character), stringsAsFactors=FALSE)

#rename column
colnames(zikacases)[1]<- "Code"


#create row of 1's and make numeric class
zikacases$Count<- 1
zikacases$Count<-as.numeric(zikacases$Count)

#aggregate 1's ... should be count of cases by airport 
z_case_code<-zikacases[,c(1,3)]
z_case_code<-aggregate(Count ~ Code, data=z_case_code, sum)

#aggregate 1's by state
z_case_state<- aggregate(Count ~ State, data=zikacases, sum)

#omit blanks -state and code
z_case_code[z_case_code==""]<-NA
z_case_code<-na.omit(z_case_code)

z_case_state[z_case_state==""]<-NA
z_case_state<-na.omit(z_case_state)

#full join (i think) by code and state to compare US sim results and case spreadsheet
require(dplyr)
mergeTP<- full_join(TP_curr_agg, z_case_code)
mergestate<-full_join(TP_curr_state_agg, z_case_state)


#rename columns -state and code
names(mergeTP)[3]<-"case_count"
names(mergeTP)[2]<-"seats"
names(mergeTP)[1]<-"code"


names(mergestate)[3]<-"case_count"
names(mergestate)[2]<-"seats"
names(mergestate)[1]<-"state"

#turn all na's to 0 - state and code
mergeTP[ is.na(mergeTP) ] <- 0
mergestate[ is.na(mergestate) ]<- 0

#change class to numeric -state and code
mergeTP$seats<-as.numeric(mergeTP$seats)
class(mergeTP$seats)

#multiply by 8.57 weeks for airport region
mergeTP$seats<- 8.57*mergeTP$seats

#write csv of airport
write.csv(mergeTP, file = "data/TP_regions_curr.csv", row.names = FALSE)

#multiply by 8.57 weeks for state
mergestate$seats<-as.numeric(mergestate$seats)
class(mergestate$seats)
mergestate$seats<- 8.57*mergestate$seats

#write csv of state
write.csv(mergestate, file = "data/TP_state_curr.csv", row.names = FALSE)

#-------GLM


