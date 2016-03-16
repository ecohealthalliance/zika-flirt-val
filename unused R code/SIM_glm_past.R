source("SIM_join_case_past.R")

merge2$sum_occur <- merge2$sum_occur / (2 * sd(merge2$sum_occur))

# Fit function to sum_occur and case_count relationship- code
fit <- glm(case_count ~ sum_occur, data = merge2, family = poisson())
summary(fit)

fitstate <- glm(case_count ~ sum_occur, data = mergestate, family = poisson())
summary(fitstate)

# Create values of sum_occur for plot
range(merge2$sum_occur)
xw <- seq(0,3716, .01)
yw <- predict(fit, list(sum_occur = xw, type = "response")
 
             

# Omit zeros and NAs for plot
is.na(merge2[merge2 == 0] ) <- TRUE
merge3 <- na.omit(merge2)

# Plot fit fucnction
plot(merge3$sum_occur, merge2$case_counts, pch = 16)

# Plot residuals
plot(fit)




                  
                  