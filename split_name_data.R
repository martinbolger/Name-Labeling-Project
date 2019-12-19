setwd("~/GitHub/Name Labeling Project")
library(devtools)

load_all('wru_martin')

write_files <- function(bool_indx, file_name){
  missing_data = name_zip_data[!bool_indx, ]
  
  write.csv(missing_data, file = file_name)
}

#Load all the csv files

name_zip_data = read.csv(file = "Dec_18_name_zip_fips_state_with_names.csv", colClasses = c("county" = "character"))

name_zip_data$first.name = gsub("[[:punct:]]", "", name_zip_data$first.name)

first_name_data = read.csv(file = "first_name_data.csv", header = T)

name_zip_data$surname.name.upper <- toupper(as.character(name_zip_data$surname))


#Find missing surnames
surname_match_indx = name_zip_data$surname.name.upper %in% surnames2010$surname


#Create missing surnames in data
missing_surnames = name_zip_data$surname[!surname_match_indx]

write.csv(missing_surnames, file ='missing_surnames.csv')

first_name_data$first.name.upper <- toupper(as.character(first_name_data$ï..firstname))

name_zip_data$first.name.upper <- toupper(as.character(name_zip_data$first.name))


first_name_match_indx = name_zip_data$first.name.upper %in% first_name_data$first.name.upper

missing_first_names = name_zip_data$first.name[!first_name_match_indx]

#Get a list of names that are not in either dataframe

name_bool = data.frame(sur_bool = surname_match_indx, first_bool =first_name_match_indx)

both_missing = Reduce("|", name_bool)

sur_missing_bool = data.frame(sur_bool = surname_match_indx, both_missing = !both_missing)

only_sur_missing = Reduce("|", sur_missing_bool)

first_missing_bool = data.frame(first_bool = first_name_match_indx, both_missing = !both_missing)

only_first_missing = Reduce("|", first_missing_bool)

bool_df = data.frame(only_sur = only_sur_missing, only_first = only_first_missing, both = both_missing)

first_last = Reduce("&", bool_df)

write_files(!first_last, 'first_last_name_included.csv')

write_files(only_sur_missing, 'missing_surnames.csv')

write_files(only_first_missing, 'missing_first_names.csv')

write_files(both_missing, 'missing_both_names.csv')




first_last_names = read.csv(file = 'first_last_name_included.csv')

missing_both_names = read.csv(file = 'missing_both_names.csv')

missing_first_names = read.csv(file = 'missing_first_names.csv')

missing_surnames = read.csv(file = 'missing_surnames.csv')

nrow(first_last_names) + nrow(missing_both_names) + nrow(missing_first_names) + nrow(missing_surnames)

nrow(name_zip_data)


 
# first_name_prob <- function(voter.file, first_name_df){
#   ## Convert Surnames in Voter File to Upper Case 
#   df <- voter.file
#   df$caseid <- 1:nrow(df)
#   df$first.name.match <- df$first.name.upper <- toupper(as.character(df$first.name))
#   p_eth <- c("p_whi", "p_bla", "p_his", "p_asi", "p_oth")
#   df <- merge(df[names(df) %in% p_eth == F], first_name_df, by.x = "first.name.match", by.y = "ï..firstname", all = TRUE)
#   df1 <- df[df$first.name.upper %in% first_name_data$ï..firstname, ]
#   df2 <- df[df$first.name.upper %in% first_name_data$ï..firstname == F, ]#Unmatched surnames
#   return(df1)
# }
# 
# name_zip_data_fn = first_name_prob(voter.file = name_zip_data, first_name_df = first_name_data)
# 
# 
# output_df_fn = predict_race(voter.file = name_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE)
# 
# write.csv(output_df_fn, file = "probability_w_fn.csv")
# 
# output_df_fn = predict_race(voter.file = name_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE)
# 
# write.csv(output_df_fn, file = "probability_wo_fn.csv")
