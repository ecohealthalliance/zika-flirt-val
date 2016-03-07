source("Join_Case_Data.R")

glm(formula = case_count ~ sum_occur, family = "poisson", data = merge)
