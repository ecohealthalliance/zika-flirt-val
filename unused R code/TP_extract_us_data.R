source("SIM_join_case_data.R")

z_case_code<-aggregate(Count ~ Code + State, data=zikacases, sum)