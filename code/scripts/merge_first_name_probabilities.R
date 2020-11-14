## ---------------------------
##
## Name: merge_first_name_probabilities.R
##
## Purpose of script: 
## Merges the first name probabilities onto the subsets 
## of the data that contain first names.
##
##
## Data Sources:
## 
## create_data_subsets.R >>
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
library(dplyr)


## set working data directory
setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## Import data:

#This is the dataset with the probabilities P(F|R)
first_name_given_race_probabilities = read.csv(file = "_input/first_name_probabilities/first_name_given_race_probabilities.csv")

#This is the dataset with the probabilities P(R|F)
race_given_first_name_probabilities = read.csv(file = "_input/first_name_probabilities/race_given_first_name_probabilities.csv")

# Import the subsets of the data that contain first names
first_last_county_ds = read.csv(file = "b_intermediate/first_last_county_ds.csv", colClasses = (county = "character"))

first_county_ds = read.csv(file = "b_intermediate/first_county_ds.csv", colClasses = (county = "character"))

first_last_ds = read.csv(file = "b_intermediate/first_last_ds.csv", colClasses = (county = "character"))

first_ds = read.csv(file = "b_intermediate/first_ds.csv", colClasses = (county = "character"))


## ---------------------------


## MERGE: Merge the first name probabilities onto the dataset for all subsets that contain first names.

first_last_county_ds <- merge(x = first_last_county_ds, y = first_name_given_race_probabilities, by.x = "firstName_upper", by.y = "ï..firstname", no.dups = TRUE)
first_last_county_ds <- merge(x = first_last_county_ds, y = race_given_first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")

first_county_ds <- merge(x = first_county_ds, y = first_name_given_race_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")
first_county_ds <- merge(x = first_county_ds, y = race_given_first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")

first_last_ds <- merge(x = first_last_ds, y = first_name_given_race_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")
first_last_ds <- merge(x = first_last_ds, y = race_given_first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")

first_ds <- merge(x = first_ds, y = first_name_given_race_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")
first_ds <- merge(x = first_ds, y = race_given_first_name_probabilities, by.x = "firstName_upper", by.y = "ï..firstname")


## Output: Output the version of the csvs with the probabilities merged on

first_last_county_ds_output_path = file.path(getwd(), "b_intermediate", "first_last_county_ds.csv")
write.csv(first_last_county_ds, file = first_last_county_ds_output_path)

last_county_ds_output_path = file.path(getwd(), "b_intermediate", "last_county_ds.csv")
write.csv(last_county_ds, file = last_county_ds_output_path)

first_county_ds_output_path = file.path(getwd(), "b_intermediate", "first_county_ds.csv")
write.csv(first_county_ds, file = first_county_ds_output_path)


first_last_ds_output_path = file.path(getwd(), "b_intermediate", "first_last_ds.csv")
write.csv(first_last_ds, file = first_last_ds_output_path)

first_ds_output_path = file.path(getwd(), "b_intermediate", "first_ds.csv")
write.csv(first_ds, file = first_ds_output_path)
