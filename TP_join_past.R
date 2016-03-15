#Start with Global Aggregated list from all 5 origin airports

library(dplyr)
library(magrittr)
library(car)

TP_past <- read.csv("data/TP_all_global_past.csv", header = TRUE, sep = ",", stringsAsFactors=FALSE)
TP_past <- filter(TP_past, Destination.Country == "United States")
TP_past_met<- TP_past[,c(6,12)]

#Do it with a pipe!
#TP_past_met <- filter(Destination.Country == "United States") %>%
  #select(6, 12)

#state aggregate. must turnt o numeric first
TP_past_state<- TP_past[,c(9,12)]
TP_past_state_agg<- aggregate(Total.Seats ~ Destination.State, data=TP_past_state, sum)
colnames(TP_past_state_agg)[1]<- "State"

#recode
TP_past$Destination <- recode(TP_past$Destination, " 'JFK'='JFK/EWR/LGA'")
TP_past$Destination <- recode(TP_past$Destination, " 'EWR'='JFK/EWR/LGA'")
TP_past$Destination <- recode(TP_past$Destination, " 'LGA'='JFK/EWR/LGA'")

TP_past$Destination <- recode(TP_past$Destination, " 'MIA'='MIA/FLL'")
TP_past$Destination <- recode(TP_past$Destination, " 'FLL'='MIA/FLL'")

TP_past$Destination <- recode(TP_past$Destination, " 'IAD'='IAD/DCA/BWI'")
TP_past$Destination <- recode(TP_past$Destination, " 'DCA'='IAD/DCA/BWI'")
TP_past$Destination <- recode(TP_past$Destination, " 'BWI'='IAD/DCA/BWI'")

TP_past$Destination <- recode(TP_past$Destination, " 'SJC'='SJC/OAK/SFO'")
TP_past$Destination <- recode(TP_past$Destination, " 'OAK'='SJC/OAK/SFO'")
TP_past$Destination <- recode(TP_past$Destination, " 'SFO'='SJC/OAK/SFO'")

#airport agg
TP_past_agg<-aggregate(Total.Seats ~ Destination, data=TP_past, sum)
colnames(TP_past_agg)[1]<- "Code"

#--------
#read in latest zika case info and subset. newest case data should be renamed current_zika_cases and injested 
zikacasesraw <- read.csv("data/zika_cases_past_fut.csv", header = TRUE, sep = ",")
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
mergeTP<- full_join(TP_past_agg, z_case_code)
mergestate<-full_join(TP_past_state_agg, z_case_state)


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
 
#multiply by 8.72 weeks for airport region
mergeTP$seats<- 8.72*mergeTP$seats

#write csv of airport
write.csv(mergeTP, file = "data/TP_regions_past.csv", row.names = FALSE)

#multiply by 8.72 weeks for state
mergestate$seats<-as.numeric(mergestate$seats)
class(mergestate$seats)
mergestate$seats<- 8.72*mergestate$seats

#write csv of state
write.csv(mergestate, file = "data/TP_state_past.csv", row.names = FALSE)

#-------GLM


