library(wru)

setwd("~/Github/Name-Labeling-Project")

name_zip_data = read.csv(file = "old code and data/name_zip_fips_state.csv", colClasses = c("county" = "character"))

predict_race(voter.file = name_zip_data, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2")


merge_surnames(name_zip_data)



census_helper(key = "a3cd003810b4773f865433c80467cb94f95860f2", voter.file = name_zip_data, states = "all", 
              geo = "county", 
              age = FALSE, 
              sex = FALSE, 
              census.data = NA, retry = retry)


data(voters)

predict_race(voter.file = voters, surname.only = T)

census.dc.nj2 <- get_census_data(key = "a3cd003810b4773f865433c80467cb94f95860f2", state = c("DC", "NJ"), age = TRUE, sex = FALSE, census.geo = "tract")  
