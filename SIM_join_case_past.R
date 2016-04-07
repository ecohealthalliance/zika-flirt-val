source("Sim_extract_us_past.R")

#read in latest zika case info and subset. newest case data should be renamed current_zika_cases and injested 
zikacases <- read.csv("rawdata/zika_cases_curr_2.csv", header = TRUE, sep = ",", stringsAsFactors=TRUE)

zikacases$report_date<-as.Date(zikacases$report_date, format = "%m/%d/%Y")

zikacases<- zikacases[ which(zikacases$report_date > "2016-01-29"),]
zikacases<-zikacases[,c(9,12)]
zikacases<- data.frame(lapply(zikacases, as.character), stringsAsFactors=FALSE)

#rename column
colnames(zikacases)[1]<- "code"

#create row of 1's and make numeric class
zikacases$Count<- 1
zikacases$Count<-as.numeric(zikacases$Count)

#aggregate 1's ... should be count of cases by airport 
z_case_code<-zikacases[,c(1,3)]
z_case_code<-aggregate(Count ~ code, data=z_case_code, sum)

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
names(merge2) <- c("code", "seats", "case_count")
names(mergestate) <- c("code", "seats", "case_count")

#turn all na's to 0 - state and code
merge2[ is.na(merge2) ] <- 0
mergestate[ is.na(mergestate) ]<- 0

write.csv(merge2, file = "data/SIM_region_past_date.csv", row.names = FALSE)
write.csv(mergestate, file = "data/SIM_state_past_date.csv", row.names = FALSE)

