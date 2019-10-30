setwd("~/GitHub/Name Labeling Project")
library(dplyr)
library(tidyverse)


name_zip_data = read.csv(file = "name_zip_fips_state_with_names.csv", colClasses = c("county" = "character"))

name_zip_data$first.name = gsub("[[:punct:]]", "", name_zip_data$first.name)


name_zip_data$first.name.upper <- toupper(as.character(name_zip_data$first.name))

name_zip_data$surname.upper <- toupper(as.character(name_zip_data$surname))

first_name_list = name_zip_data$first.name.upper

surname_list = name_zip_data$surname.upper

unique_surname = unique(name_zip_data$surname.upper)

unique_first_name = unique(name_zip_data$first.name.upper)

name_count <- function(name, df){
  name_string = paste('\\<', name, '\\>', sep = '')
  length(grep(name_string, df))
}

#Get the name counts

first_name_counts = sapply(unique_first_name, name_count, df = first_name_list)

surname_counts = sapply(unique_surname, name_count, df = surname_list)


# Inport the split name lists


first_last_names = read.csv(file = 'first_last_name_included.csv', colClasses = c("county" = "character"))

missing_both_names = read.csv(file = 'missing_both_names.csv', colClasses = c("county" = "character"))

missing_first_names = read.csv(file = 'missing_first_names.csv', colClasses = c("county" = "character"))

missing_surnames = read.csv(file = 'missing_surnames.csv', colClasses = c("county" = "character"))

nrow(first_last_names) + nrow(missing_both_names) + nrow(missing_first_names) + nrow(missing_surnames)

missing_both_names$first.name.upper

get_name_count <- function(name, df){
  df[toString(name)]
}

#Add counts to dataframes:

#Both missing
missing_both_names$first_name_counts = sapply(missing_both_names$first.name.upper, get_name_count, df = first_name_counts)

missing_both_names$surname_counts = sapply(missing_both_names$surname.name.upper, get_name_count, df = surname_counts)

#First Missing

missing_first_names$first_name_counts = sapply(missing_first_names$first.name.upper, get_name_count, df = first_name_counts)

missing_first_names$surname_counts = sapply(missing_first_names$surname.name.upper, get_name_count, df = surname_counts)

#Surname Missing

missing_surnames$first_name_counts = sapply(missing_surnames$first.name.upper, get_name_count, df = first_name_counts)

missing_surnames$surname_counts = sapply(missing_surnames$surname.name.upper, get_name_count, df = surname_counts)

#First and Surname Present

first_last_names$first_name_counts = sapply(first_last_names$first.name.upper, get_name_count, df = first_name_counts)

first_last_names$surname_counts = sapply(first_last_names$surname.name.upper, get_name_count, df = surname_counts)


write.csv(first_last_names, file = 'first_last_name_included.csv')

write.csv(missing_both_names, file = 'missing_both_names.csv')

write.csv(missing_first_names, file = 'missing_first_names.csv')

write.csv(missing_surnames, file = 'missing_surnames.csv')

