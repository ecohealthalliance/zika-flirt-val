source("extract_us_codes.R")


zikacasesraw <- read.csv("~/Repositories/zika-flirt-val/data/current_zika_cases.csv", header = TRUE, sep = ",")

zikacases<-zikacasesraw[,c(8,9)]
zikacases<- data.frame(lapply(zikacases, as.character), stringsAsFactors=FALSE)

#rename column
colnames(zikacases)[1]<- "Code"

#create row of 1's
zikacases$Count<- 1

#make new row of 1's numeric class
zikacases$Count<-as.numeric(zikacases$Count)

#aggregate 1's ... should be count of cases by airport
z_case_code<-aggregate(Count ~ Code + State, data=zikacases, sum)

#omit blanks
z_case_code[z_case_code==""]<-NA
z_case_code<-na.omit(z_case_code)

#write to csv
#write.csv(us_onlysim, file="US_Only_Sim_inner.csv")

#inner join (can also use semi?? not sure) by code to compare US sim results and case spreadsheet
#THIS PART NEEDS TO BE FIXED- MERGED DATA IS NOT CORRECT
require(dplyr)
merge<- inner_join(us_onlysim, z_case_code)

#rename columns 
names(merge)[4]<-"case_count"
names(merge)[3]<-"state"
names(merge)[1]<-"code"

#change class to numeric
merge$sum_occur<-as.numeric(merge$sum_occur)
class(merge$sum_occur)
