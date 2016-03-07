source("extract_us_codes.R")

#read in latest zika case info and subset
zikacasesraw <- read.csv("~/Repositories/zika-flirt-val/data/current_zika_cases.csv", header = TRUE, sep = ",")
zikacases<-zikacasesraw[,c(8,9)]
zikacases<- data.frame(lapply(zikacases, as.character), stringsAsFactors=FALSE)

#rename column
colnames(zikacases)[1]<- "Code"

#create row of 1's and make numeric class
zikacases$Count<- 1
zikacases$Count<-as.numeric(zikacases$Count)

#aggregate 1's ... should be count of cases by airport
z_case_code<-aggregate(Count ~ Code + State, data=zikacases, sum)

#omit blanks
z_case_code[z_case_code==""]<-NA
z_case_code2<-na.omit(z_case_code)

#write to csv
#write.csv(us_onlysim, file="US_Only_Sim_inner.csv")

#full join (i think) by code to compare US sim results and case spreadsheet
require(dplyr)
#merge<- inner_join(usonlysim_agg, z_case_code)
merge2<- full_join(usonlysim_agg, z_case_code2)

#rename columns 
names(merge2)[4]<-"case_count"
names(merge2)[3]<-"sum_occur"
names(merge2)[1]<-"code"

#turn all na's to 0
merge2[ is.na(merge2) ] <- 0)

#change class to numeric
merge2$sum_occur<-as.numeric(merge2$sum_occur)
class(merge2$sum_occur)


