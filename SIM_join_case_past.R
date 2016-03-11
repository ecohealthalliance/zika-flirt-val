source("Sim_extract_us_past.R")

#read in latest zika case info and subset. newest case data should be renamed current_zika_cases and injested 
zikacasesraw <- read.csv("data/zika_cases_past_fut.csv", header = TRUE, sep = ",")
zikacases<-zikacasesraw[,c(9,10)]
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
merge2<- full_join(usonlysimpast_met_agg, z_case_code)
mergestate<-full_join(usonlysimpast_agg_state, z_case_state)


#rename columns -state and code
names(merge2)[3]<-"case_count"
names(merge2)[2]<-"sum_occur"
names(merge2)[1]<-"code"


names(mergestate)[3]<-"case_count"
names(mergestate)[2]<-"sum_occur"
names(mergestate)[1]<-"state"

#turn all na's to 0 - state and code
merge2[ is.na(merge2) ] <- 0
mergestate[ is.na(mergestate) ]<- 0

#change class to numeric -state and code
merge2$sum_occur<-as.numeric(merge2$sum_occur)
class(merge2$sum_occur)
write.csv(merge2, file = "data/regions_past.csv", row.names = FALSE)

mergestate$sum_occur<-as.numeric(mergestate$sum_occur)
class(mergestate$sum_occur)
write.csv(mergestate, file = "data/state_past.csv", row.names = FALSE)

