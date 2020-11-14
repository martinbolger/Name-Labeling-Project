## ---------------------------
##
## Name: flag_name_data.R
##
## Purpose of script: 
## Creates subsets of the data based on the presence or
## absence of different variable values. 
##
## The values are: The first and last name and the FIPS county code.
##
## Data Sources:
## 
## separate_first_last_names.R >>
## nameslist_clean_name_data.csv
##  This is the list of names separated into first and last names.
##   
## Author: Martin Bolger
##
## Date Created: 2020.11.07

## ---------------------------

## load up the packages/libraries we will need:
library(devtools)

setwd("~/GitHub/Name-Labeling-Project")
load_all('wru_martin')

## set working data directory
setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## Import data:

#This is the dataset of first name race probabilities
first_name_probabilities = read.csv(file = "_input/first_name_probabilities/first_name_given_race_probabilities.csv")

# This is the cleaned list of names
nameslist_ds = read.csv("a_working/nameslist_clean.csv", colClasses = (FIPS_clean = "character"))

## ---------------------------

## Create "notin" for convenience
`%notin%` <- Negate(`%in%`)


## FLAG: Remove the entries with no county

no_county_index = which(is.na(nameslist_ds$FIPS))

nameslist_ds$no_county_flag[nameslist_ds$ID %in% no_county_index] <- 1


# FLAG: Flag surnames that are not in the census data
surname_match_indx = nameslist_ds$lastName_upper %notin% surnames2010$surname

nameslist_ds$last_name_missing_flag[surname_match_indx] <- 1

# FLAG: Flag first names that are not in the first name probability data

first_name_match_indx = nameslist_ds$firstName_upper %notin% first_name_probabilities$ï..firstname

nameslist_ds$first_name_missing_flag[first_name_match_indx] <- 1

output_path = file.path(getwd(), "b_intermediate", "nameslist_clean_with_flags.csv")
write.csv(nameslist_ds, file = output_path)

