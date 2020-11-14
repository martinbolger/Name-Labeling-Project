## ---------------------------
##
## Name: create_data_subsets.R
##
## Purpose of script: ==
## Creates the subsets of the data for the predictor.
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

## set working data directory
setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## Import data:

# This is the dataset of first name race probabilities
first_name_probabilities = read.csv(file = "_input/first_name_probabilities/first_name_data.csv")

# This is the dataset with the full cleaned data
nameslist_ds = read.csv("b_intermediate/nameslist_clean_flags_fips.csv", colClasses = (FIPS_clean = "character"))


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

## OUTPUT: Output the datasets to CSV
first_last_county_ds_output_path = file.path(getwd(), "b_intermediate", "first_last_county_ds.csv")
write.csv(first_last_county_ds, file = first_last_county_ds_output_path)

last_county_ds_output_path = file.path(getwd(), "b_intermediate", "last_county_ds.csv")
write.csv(last_county_ds, file = last_county_ds_output_path)

first_county_ds_output_path = file.path(getwd(), "b_intermediate", "first_county_ds.csv")
write.csv(first_county_ds, file = first_county_ds_output_path)


first_last_ds_output_path = file.path(getwd(), "b_intermediate", "first_last_ds.csv")
write.csv(first_last_ds, file = first_last_ds_output_path)


county_ds_output_path = file.path(getwd(), "b_intermediate", "county_ds.csv")
write.csv(county_ds, file = county_ds_output_path)


last_ds_output_path = file.path(getwd(), "b_intermediate", "last_ds.csv")
write.csv(last_ds, file = last_ds_output_path)


first_ds_output_path = file.path(getwd(), "b_intermediate", "first_ds.csv")
write.csv(first_ds, file = first_ds_output_path)


all_missing_ds_output_path = file.path(getwd(), "c_output", "all_missing_ds.csv")
write.csv(all_missing_ds, file = all_missing_ds_output_path)

