source("SIM_join_case_curr.R")

#fit function to sum_occur and case_count relationship- code
fit<- glm(case_count ~ sum_occur, data = merge2, family=poisson())
summary(fit)

fit<- glm(case_count ~ sum_occur, data = mergestate, family=poisson())
summary(fit)

fitstate<- glm(case_count ~ sum_occur, data=mergestate, family = poisson())
summary(fitstate)

#turn fit function into linear model
fit<- lm(fit, data=merge2)
#fitstate< lm(fitstate, data=mergestate)-- NO PLOT YET FOR STATE DATA

#create values of sum_occur for plot
range(merge2$sum_occur)
xw<- seq(0,3716, .01)
yw<- predict(fit, list(sum_occur= xw, type="response")
             
             
             
             #omit zeros and NAs for plot
             is.na(merge2[merge2==0] ) <- TRUE
             merge3<-na.omit(merge2)
             
             #plot fit fucnction
             plot(merge3$sum_occur, merge2$case_counts, pch = 16)
             
             #plot residuals
             plot(fit)
             
             
             
             
             
             