source("Extract_US_codes.R")


zikacasesraw <- read.csv("Zika U.S. Cases 3-3-2016.csv", header = TRUE, sep = ",")

zikacase<-zikacasesraw[,c(8,9)]

zikacase<- data.frame(lapply(zikacase, as.character), stringsAsFactors=FALSE)

#rename column
colnames(zikacase)[1]<- "Code"

#create row of 1's
zikacase$Count<- 1

#make new row of 1's numeric class
zikacase$Count<-as.numeric(zikacase$Count)

#aggregate 1's ... should be count of cases by airport
z_case_code<-aggregate(Count ~ Code + State, data=zikacase, sum)

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
