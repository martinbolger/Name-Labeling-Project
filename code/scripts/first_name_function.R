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

#This is the dataset of first name race probabilities
first_name_probabilities = read.csv(file = "_input/first_name_probabilities/first_name_data.csv")

# # Rename the first name variable
# first_name_probabilities %>% 
#   rename(
#     first_name = ï..firstname
#   )

# This is the dataset of state-level race probabilities
state_geo_probs = read.csv(file = "_input/geographic_probabilities_by_state/geographic_probabilities_by_state.csv", header = T)

# This is the cleaned list of names
nameslist_ds = read.csv("b_intermediate/nameslist_clean_flags_fips.csv", colClasses = (county = "character"))

# Rename the variables for the census api
nameslist_ds$first.name = nameslist_ds$firstName
nameslist_ds$surname = nameslist_ds$lastName
nameslist_ds$county = nameslist_ds$FIPS_county
nameslist_ds$state = toupper(nameslist_ds$stusps)

## ---------------------------

## SUBSET: Create a subset of the data for every possible combination of the flags

# Nothing is missing
first_last_county_ds = nameslist_ds[which(is.na(nameslist_ds$first_name_missing_flag) & is.na(nameslist_ds$last_name_missing_flag) & is.na(nameslist_ds$no_county_flag)),]

# Only first name is missing
last_county_ds = nameslist_ds[which(nameslist_ds$first_name_missing_flag == 1 & is.na(nameslist_ds$last_name_missing_flag) & is.na(nameslist_ds$no_county_flag)),]

# Only last name is missing
first_county_ds = nameslist_ds[which(is.na(nameslist_ds$first_name_missing_flag) & nameslist_ds$last_name_missing_flag == 1 & is.na(nameslist_ds$no_county_flag)),]

# Only the county is missing
first_last_ds = nameslist_ds[which(is.na(nameslist_ds$first_name_missing_flag) & is.na(nameslist_ds$last_name_missing_flag) & nameslist_ds$no_county_flag == 1),]

# The last name and the county are missing
first_ds = nameslist_ds[which(is.na(nameslist_ds$first_name_missing_flag) & nameslist_ds$last_name_missing_flag == 1 & nameslist_ds$no_county_flag == 1),]

# The first and last names are missing
county_ds = nameslist_ds[which(nameslist_ds$first_name_missing_flag == 1 & nameslist_ds$last_name_missing_flag == 1 & is.na(nameslist_ds$no_county_flag)),]

# The first name and county are missing
last_ds = nameslist_ds[which(nameslist_ds$first_name_missing_flag == 1 & is.na(nameslist_ds$last_name_missing_flag) & nameslist_ds$no_county_flag == 1),]

# Everything is missing

all_missing_ds = nameslist_ds[which(nameslist_ds$first_name_missing_flag == 1 & nameslist_ds$last_name_missing_flag == 1 & nameslist_ds$no_county_flag == 1),]


## DATA CHECK: Make sure that the size of the subsets are equal to the full dataset size
subset_size = dim(all_missing_ds)[1] + dim(first_last_county_ds)[1] + dim(last_county_ds)[1] + dim(first_county_ds)[1] + dim(first_last_ds)[1] + dim(first_ds)[1] + dim(county_ds)[1] + dim(last_ds)[1]
total_size = dim(nameslist_ds)[1]

# Make sure that we don't have any truncated fips codes
if (subset_size != total_size){
  print("The subset datasets' size does not equal the original dataset's size.")
}

## MERGE: Merge the first name probabilities onto the dataset for all subsets that contain first names.

first_last_county_ds <- merge(x = first_last_county_ds, y = first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")

first_county_ds <- merge(x = first_county_ds, y = first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")

first_last_ds <- merge(x = first_last_ds, y = first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")

first_ds <- merge(x = first_ds, y = first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")




## PREDICT: This step calls the census API for each subset of the data to get the predictions

output_first_last_county_ds = predict_race(voter.file = first_last_county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2")#, first_name = TRUE, surname = TRUE)

output_last_county_ds = predict_race(voter.file = last_county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = TRUE)

output_first_county_ds = predict_race(voter.file = first_county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE, surname = FALSE)

output_first_last_ds = predict_race(voter.file = first_last_ds, census.geo = "no_county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE, surname = TRUE)

output_first_ds = predict_race(voter.file = first_ds, census.geo = "no_county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE, surname = FALSE)

output_county_ds = predict_race(voter.file = county_ds, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = FALSE)

output_last_ds = predict_race(voter.file = last_ds, census.geo = "no_county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = TRUE)




write.csv(output_df_fn, file = "output_first_last_county_ds")

total_len = total_len + nrow(output_df_fn)




#Names in the no county list have fips code, so the geographic probabilities are computed at the state level. 
#It is assumed that the first and last name is in the data for these names (you need to modify the code if you want to split them up into more sub-groups)

output_df_fn = predict_race(voter.file = no_county_zip_data_fn, census.geo = "no_county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2") 

write.csv(output_df_fn, file = "probability_using_first_last_state_level_loc.csv")

total_len = total_len + nrow(output_df_fn)


#Names in the first_last_names list have a first and last name that appears in the data

output_df_fn = predict_race(voter.file = first_last_names_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2")#, first_name = TRUE, surname = TRUE)

write.csv(output_df_fn, file = "probability_using_first_last_loc.csv")

total_len = total_len + nrow(output_df_fn)


#Names in the missing both names list have a first and last name that are not in a list

output_df_fn = predict_race(voter.file = missing_both_names, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = FALSE)

write.csv(output_df_fn, file = "probability_loc.csv")

total_len = total_len + nrow(output_df_fn)


#Names in the missing surname list have a first name that appears in the data


output_df_fn = predict_race(voter.file = missing_surnames_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = FALSE)

write.csv(output_df_fn, file = "probability_loc_w_first.csv")

total_len = total_len + nrow(output_df_fn)


#Names in the missing first names list have a last name that appears in the data

output_df_fn = predict_race(voter.file = missing_first_names, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = TRUE)

write.csv(output_df_fn, file = "probability_last_loc.csv")

total_len = total_len + nrow(output_df_fn)

print(total_len)



census = census_geo_api("a3cd003810b4773f865433c80467cb94f95860f2", state = "oh", geo = 'county', age = FALSE, sex = FALSE)






