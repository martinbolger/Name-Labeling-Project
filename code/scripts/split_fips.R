## ---------------------------
##
## Name: split_fips.R
##
## Purpose of script: 
## Splits the fips code into the state and county parts
## the state abbreviation is also added to the dataset.
##
## Data Sources:
## nameslist_clean_with_flags.csv
## This is the output from flag_name_data.R. It is the
## version of the input data with the names separated.
## 
## us-state-ansi-fips.csv
##  This is the list of fips codes and state abbreviations.
##   
## Author: Martin Bolger
##
## Date Created: 2020.11.07

setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## load up the packages/libraries we will need:
library(dplyr)
library(tidyr)

## ---------------------------

## Import data:

fips_to_state = read.csv("_input/fips_to_state/us-state-ansi-fips.csv", colClasses = (st = "character"))

# Remove extra spaces in the state variable
fips_to_state$stusps = trimws(fips_to_state$stusps)

nameslist_ds = read.csv("b_intermediate/nameslist_clean_with_flags.csv", colClasses = (FIPS_clean = "character"))

## ---------------------------

## CREATE FUNCTION: Create a function for finding integer(0)
is.integer0 <- function(x)
{
  is.integer(x) && length(x) == 0L
}


## DATA CHECK: Calcuate the length of the fips codes. Make sure that we don't have any 
## truncated values
nameslist_ds$FIPS_chars = nchar(nameslist_ds$FIPS_clean)

short_fips_index = which(nameslist_ds$FIPS_chars < 5 & is.na(nameslist_ds$no_county_flag))


# Make sure that we don't have any truncated fips codes
if (!(identical(short_fips_index, integer(0)))){
  print("There are truncated values for the FIPS code, ending")
}

nameslist_ds = separate(nameslist_ds, FIPS_clean, into = c("FIPS_state", "FIPS_county"), sep = 2, remove = FALSE)

setdiff(nameslist_ds$FIPS_state ,fips_to_state$st)

## MERGE: Merge on the state abbreviations
merged_ds = merge(x = nameslist_ds, y = fips_to_state, by.x = "FIPS_state", by.y = "st", all.x = TRUE)


## SUBSET: Subset to unsupported states/territories
unsupported_ds = merged_ds[which(!is.na(merged_ds$FIPS_state) & is.na(merged_ds$stusps)),]

## OUTPUT: Output any observations that are from an unsupported state/territory
output_path = file.path(getwd(), "c_output", "unsupported_state_territory_obs.csv")
write.csv(unsupported_ds, file = output_path)


## SUBSET: Now we can remove any observations from unsupported states
if(!is.integer0(which(!is.na(merged_ds$FIPS_state) & is.na(merged_ds$stusps)))){
  merged_ds = merged_ds[-which(!is.na(merged_ds$FIPS_state) & is.na(merged_ds$stusps)),]
}
  
## OUTPUT: Output the updated dataset as a CSV
output_path = file.path(getwd(), "b_intermediate", "nameslist_clean_flags_fips.csv")
write.csv(merged_ds, file = output_path)
