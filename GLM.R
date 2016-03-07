source("join_case_data.R")

glm(formula = case_count ~ sum_occur, family = "poisson", data = merge)
