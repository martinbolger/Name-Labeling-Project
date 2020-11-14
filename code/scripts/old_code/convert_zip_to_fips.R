## ---------------------------
##
## Name: convert_zip_to_fips.R
##
## Purpose of script: 
## Convert ZIP codes to county FIPS codes
##
## Data Sources:
## COUNTY_ZIP_062020.xlsx
##    This is the ZIP to FIPs crosswalk file from the HUD website.
##    This copy is for the second quarter of 2020.
## 
## nameslist.csv
##  This is the list of names with corresponding zips that are 
##  being profiled.
##   
## Author: Martin Bolger
##
## Date Created: 2020.10.03

## set working data directory

setwd("~/GitHub/Name-Labeling-Project/data")

## ---------------------------

## load up the packages/libraries we will need:
library(wru)
library(readxl)

## ---------------------------

## Import data:

zip_to_fips_ds = read_excel("_input/zip_to_fips_data/COUNTY_ZIP_062020.xlsx")

nameslist_ds = read.csv("_input/name_data/nameslist.csv")

## ---------------------------


dup_list = zip_to_fips_ds[duplicated(zip_to_fips_ds$ZIP),]

merge_test_dups = merge(nameslist_ds, dup_list, by.x="zip", by.y="ZIP")

write.csv(merge_test_dups, file = "b_intermediate/merge_test.csv")

# Get the length of the dataset nameslist
nameslist_len = nrow(nameslist_ds)

# Create a copy of the nameslist dataset with empty columns for the state and fips code
nameslist_update = cbind(nameslist_ds, state = 0, fips = 0)


merge_test = merge(nameslist_ds, zip_to_fips_ds, by.x="zip", by.y="ZIP")

write.csv(merge_test, file = "b_intermediate/merge_test.csv")




for (i in c(1:nameslist_len)){
  cur_zip = nameslist_ds$zip[i]
  # If the zip code is fewer than 4 digits long, it can't be a valid zip code.
  if (nchar(cur_zip) < 4){
    nameslist_update[i, 'fips'] = 'no data'
    next
  }
  # If the zip code is four digits long, we need to pad it with a zero.
  if (nchar(cur_zip) == 4){
    cur_zip = paste("0", cur_zip, sep = "")
  }
  # If they are both misssing, make the state and fips code blank
  if ((nrow(zip_to_fips_ds[which(zip_to_fips_ds$ZIP == cur_zip),]) == 0)){
    nameslist_update[i, 'fips'] = 'no data'
    next
  } 
  #If the main df has an entry for the zip code, use it's value
  else if (nrow(zip_to_fips_ds[which(zip_to_fips_ds$ZIP == cur_zip),]) > 0){ 
    fips_code = zip_to_fips_ds[which(zip_to_fips_ds$ZIP == cur_zip), 'COUNTY'][1]
  }
  # Now we need to split the fips code into the county code and the state code.
  if (nchar(fips_code) == 5){
    fips_num = substr(fips_code, 3, nchar(fips_code))
  }
  if (nchar(fips_code) == 4){
    fips_num = substr(fips_code, 2, nchar(fips_code))
  }
  nameslist_update[i, 'state'] = toString(state_a)
  nameslist_update[i, 'fips'] = fips_num
}

write.csv(nameslist_update, file = "b_intermediate/name_zip_fips_state_Dec_18.csv")

