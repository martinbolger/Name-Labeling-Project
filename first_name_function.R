setwd("~/GitHub/Name Labeling Project")
library(devtools)
library(dplyr)
library(tidyverse)

load_all('wru_martin')


first_name_data = read.csv(file = "first_name_data.csv", header = T)


first_last_names = read.csv(file = 'first_last_name_included.csv', colClasses = c("county" = "character"))

missing_both_names = read.csv(file = 'missing_both_names.csv', colClasses = c("county" = "character"))

missing_first_names = read.csv(file = 'missing_first_names.csv', colClasses = c("county" = "character"))

missing_surnames = read.csv(file = 'missing_surnames.csv', colClasses = c("county" = "character"))

nrow(first_last_names) + nrow(missing_both_names) + nrow(missing_first_names) + nrow(missing_surnames)

# nrow(name_zip_data)




first_name_prob <- function(voter.file, first_name_df){
  ## Convert Surnames in Voter File to Upper Case 
  df <- voter.file
  df$caseid <- 1:nrow(df)
  df$first.name.match <- df$first.name.upper <- toupper(as.character(df$first.name))
  p_eth <- c("p_whi", "p_bla", "p_his", "p_asi", "p_oth")
  df <- merge(df[names(df) %in% p_eth == F], first_name_df, by.x = "first.name.match", by.y = "ï..firstname", all = TRUE)
  df1 <- df[df$first.name.upper %in% first_name_data$ï..firstname, ]
  df2 <- df[df$first.name.upper %in% first_name_data$ï..firstname == F, ]#Unmatched surnames
  return(df1)
}

first_last_names_zip_data_fn = first_name_prob(voter.file = first_last_names, first_name_df = first_name_data)

missing_both_names_zip_data_fn = first_name_prob(voter.file = missing_both_names, first_name_df = first_name_data)

missing_first_names_zip_data_fn = first_name_prob(voter.file = missing_first_names, first_name_df = first_name_data)

missing_surnames_zip_data_fn = first_name_prob(voter.file = missing_surnames, first_name_df = first_name_data)





#Names in the first_last_names list have a first and last name that appears in the data

output_df_fn = predict_race(voter.file = first_last_names_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2")#, first_name = TRUE, surname = TRUE)

write.csv(output_df_fn, file = "probability_using_first_last_loc.csv")


#Names in the missing both names list have a first and last name that are not in a list

output_df_fn = predict_race(voter.file = missing_both_names, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = FALSE)

write.csv(output_df_fn, file = "probability_loc.csv")


#Names in the missing surname list have a first name that appears in the data


output_df_fn = predict_race(voter.file = missing_surnames_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = FALSE)

write.csv(output_df_fn, file = "probability_loc_w_first.csv")


#Names in the missing first names list have a last name that appears in the data

output_df_fn = predict_race(voter.file = missing_first_names, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE, surname = TRUE)

write.csv(output_df_fn, file = "probability_last_loc.csv")



census = census_geo_api("a3cd003810b4773f865433c80467cb94f95860f2", state = "all", geo = 'county', age = FALSE, sex = FALSE)






