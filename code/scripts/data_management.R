## ---------------------------
##
## Name: data_management.R
##
## Purpose of script: 
## Splits the full names from the input data into first
## and last names. Cleans the data by removing punctuation
## and creating an uppercase version of each name.
##
## Data Sources:
## 
## nameslist.csv
##  This is the list of names with corresponding zips that are 
##  being profiled.
##   
## Author: Martin Bolger
##
## Date Created: 2020.11.07

## set working data directory

setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## load up the packages/libraries we will need:
library(humanparser)
library(dplyr)

## ---------------------------

## Import data:

nameslist_ds = read.csv("_input/name_data/nameslist.csv")

## ---------------------------


## CLEANING: This section cleans the names. 

# Remove all non-alphabetic characters
nameslist_ds$name_no_punctuation = gsub("[^A-Za-z\\s-]", "\\", nameslist_ds$Name, perl=TRUE)

# Create a true/false variable that indicates which strings were modified
# when removing non-alphabetic characters
nameslist_ds$name_has_punctuation = grepl("[^A-Za-z\\s-]", nameslist_ds$Name, perl=TRUE)

# Count the number of words in each string
nameslist_ds$word_count = sapply(gregexpr("\\S+", nameslist_ds$Name), length)


## SUBSET: Create a subset of the observations with 6 or more words
## to create the invalid names dataset
nameslist_ds_invalid_names = nameslist_ds[-which(nameslist_ds$word_count <= 5),]

## OUTPUT: Output the invalid names dataset
output_path = file.path(getwd(), "c_output", "invalid_names.csv")
write.csv(nameslist_ds_invalid_names, file = output_path)



## SUBSET: Subset to names with fewer than 6 words
nameslist_ds_subset = nameslist_ds[which(nameslist_ds$word_count <= 5),]





# Drop the old ID variable and add a new ID variable
nameslist_ds_subset = select(nameslist_ds_subset, -1)

nameslist_ds_subset$ID <- seq.int(nrow(nameslist_ds_subset))


## PARSING: After the names have been cleaned, we are ready 
## to separate them into first and last names.
parsed_names_ds = parse_names(nameslist_ds_subset$name_no_punctuation)

# Add a row ID to the parsed names list so that we have a unique identifier 
# to use for merging the data onto the main dataset
parsed_names_ds$ID <- seq.int(nrow(parsed_names_ds))


## MERGING: Merge the parsed names back onto the dataset
output_ds = merge(nameslist_ds_subset, parsed_names_ds, by = "ID")

## CLEAN: Clean the output by making the first and last names upper case
output_ds$firstName_upper <- toupper(as.character(output_ds$firstName))
output_ds$lastName_upper <- toupper(as.character(output_ds$lastName))
output_ds$middleName_upper <- toupper(as.character(output_ds$middleName))

# Make any missing fips code an actual N/A
output_ds$FIPS[output_ds$FIPS == "N/A"] = NA
# Pad all FIPS codes so that they contain 5 digits
output_ds$FIPS_clean <- ifelse(is.na(output_ds$FIPS), NA, sprintf("%05s",output_ds$FIPS))
output_ds$FIPS_chars = nchar(output_ds$FIPS_clean)


## REORDER: Reorder the variables on the output

col_order <- c("ID", "Name", "name_no_punctuation", "fullName", 
               "firstName", "firstName_upper",
               "middleName", "middleName_upper",
               "lastName", "lastName_upper", "suffix", "salutation", 
               "word_count", "name_has_punctuation", "Street", 
               "City", "State", "ZIP", "FIPS", "FIPS_clean")

output_ds <- output_ds[, col_order]

# Drop the variable name_no_punctuation
output_ds = select(output_ds, -3)

## OUTPUT: Output the updated dataset as a CSV
output_path = file.path(getwd(), "a_working", "nameslist_clean.csv")
write.csv(output_ds, file = output_path)

