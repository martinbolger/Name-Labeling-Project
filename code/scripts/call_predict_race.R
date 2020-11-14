## ---------------------------
##
## Name: run_predictor.R
##
## Purpose of script: 
## Calculates the probabilities.
##
##
## Data Sources:
## 
## split_fips.R >>
## nameslist_clean_flags_fips.csv
##  This is the final version of the names list after it 
## has been cleaned and teh fips codes have been split
## into county and state codes.
##   
## Author: Martin Bolger
##
## Date Created: 2020.11.08

## ---------------------------

## load up the packages/libraries we will need:
setwd("~/GitHub/Name-Labeling-Project")
library(devtools)
library(dplyr)

load_all('wru_martin')

## set working data directory
setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## Import data:

# Import the subsets of the data


## ---------------------------

## PREDICT: This step calls the census API for each subset of the data to get the predictions

output_first_last_county_ds = predict_race(voter.file = first_last_county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2")#, first_name = TRUE, surname = TRUE)

output_last_county_ds = predict_race(voter.file = last_county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = TRUE)

output_first_county_ds = predict_race(voter.file = first_county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE, surname = FALSE)

output_first_last_ds = predict_race(voter.file = first_last_ds, census.geo = "no_county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE, surname = TRUE)

output_county_ds = predict_race(voter.file = county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = FALSE)

output_last_ds = predict_race(voter.file = last_ds, census.geo = "no_county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = TRUE)


## Rename: The first name probabilities are already on the dataset first_ds, so we just need to 
## rename them so that they follow the format of the variable name format of the other datasets.
first_ds$pred.his = first_ds$p_r_f_his
first_ds$pred.whi = first_ds$p_r_f_whi
first_ds$pred.bla = first_ds$p_r_f_bla
first_ds$pred.asi = first_ds$p_r_f_asi
first_ds$pred.oth = first_ds$p_r_f_oth
output_first_ds = first_ds

## FLAGS: Add flags for the variables that were used to calculate the probability
output_first_last_county_ds$first <- rep(1,nrow(output_first_last_county_ds)) 
output_first_last_county_ds$last <- rep(1,nrow(output_first_last_county_ds)) 
output_first_last_county_ds$county <- rep(1,nrow(output_first_last_county_ds))

output_last_county_ds$first <- rep(0,nrow(output_last_county_ds))
output_last_county_ds$last <- rep(1,nrow(output_last_county_ds)) 
output_last_county_ds$county <- rep(1,nrow(output_last_county_ds))

output_first_county_ds$first <- rep(1,nrow(output_first_county_ds)) 
output_first_county_ds$last <- rep(0,nrow(output_first_county_ds)) 
output_first_county_ds$county <- rep(1,nrow(output_first_county_ds))

output_first_last_ds$first <- rep(1,nrow(output_first_last_ds)) 
output_first_last_ds$last <- rep(1,nrow(output_first_last_ds)) 
output_first_last_ds$county <- rep(0,nrow(output_first_last_ds))

output_county_ds$first <- rep(0,nrow(output_county_ds)) 
output_county_ds$last <- rep(0,nrow(output_county_ds)) 
output_county_ds$county <- rep(1,nrow(output_county_ds))

output_last_ds$first <- rep(0,nrow(output_last_ds)) 
output_last_ds$last <- rep(1,nrow(output_last_ds)) 
output_last_ds$county <- rep(0,nrow(output_last_ds))

output_first_ds$first <- rep(0,nrow(output_first_ds)) 
output_first_ds$last <- rep(1,nrow(output_first_ds)) 
output_first_ds$county <- rep(0,nrow(output_first_ds))


## DROP VARIABLES: Drop all of the variables that we don't want to create cleaner
## output datasets
keep_vars = c("ID", "Name", "fullName", "firstName", "middleName", "lastName", "suffix", "salutation", 
              "FIPS", "pred.whi", "pred.bla", "pred.his", "pred.asi", "pred.oth", "first", "last", "county")

## OUTPUT: Output the updated dataset as a CSV
# output_path = file.path(getwd(), "c_output", "output_first_last_county_ds.csv")
# write.csv(output_first_last_county_ds[keep_vars], file = output_path)
# 
# output_path = file.path(getwd(), "c_output", "output_last_county_ds.csv")
# write.csv(output_last_county_ds[keep_vars], file = output_path)
# 
# output_path = file.path(getwd(), "c_output", "output_first_county_ds.csv")
# write.csv(output_first_county_ds[keep_vars], file = output_path)
# 
# output_path = file.path(getwd(), "c_output", "output_first_last_ds.csv")
# write.csv(output_first_last_ds[keep_vars], file = output_path)
# 
# output_path = file.path(getwd(), "c_output", "output_county_ds.csv")
# write.csv(output_county_ds[keep_vars], file = output_path)
# 
# output_path = file.path(getwd(), "c_output", "output_last_ds.csv")
# write.csv(output_last_ds[keep_vars], file = output_path)
# 
# output_path = file.path(getwd(), "c_output", "output_first_ds.csv")
# write.csv(output_first_ds[keep_vars], file = output_path)

full_stacked_predictions = rbind(output_first_last_county_ds[keep_vars], output_last_county_ds[keep_vars], 
      output_first_county_ds[keep_vars], output_first_last_ds[keep_vars],
      output_county_ds[keep_vars], output_last_ds[keep_vars], output_first_ds[keep_vars])

## SORT: Convert the ID variable to a numeric and sort
full_stacked_predictions$ID = as.numeric(full_stacked_predictions$ID)
full_stacked_predictions_sort = full_stacked_predictions[order(full_stacked_predictions$ID),]

output_path = file.path(getwd(), "c_output", "full_stacked_predictions_sort.csv")
write.csv(full_stacked_predictions_sort, file = output_path)

