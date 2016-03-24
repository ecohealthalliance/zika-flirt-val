TP_global <- read.csv("rawdata/flirt_output/TP_all_global_past_2.csv", header = TRUE, sep = ",", stringsAsFactors=FALSE) 

TP_global<-  TP_global[,c(6,12)]
  
colnames(TP_global)<- c("code", "seats")

TP_global_agg<-aggregate(seats ~ code, data = TP_global, sum)

write.csv(TP_global_agg, file = "data/TP_global_ranks_2.csv", row.names = FALSE)

