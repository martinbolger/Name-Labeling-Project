setwd("~/Python_Scripts/Name Labeling Project")

library(devtools)

load_all('wru_martin')


name_zip_data = read.csv(file = "name_zip_fips_state_with_names.csv", colClasses = c("county" = "character"))


first_name_data = read.csv(file = "first_name_data.csv", header = T)


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

name_zip_data_fn = first_name_prob(voter.file = name_zip_data, first_name_df = first_name_data)


output_df_fn = predict_race(voter.file = name_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = TRUE)

write.csv(output_df_fn, file = "probability_w_fn.csv")

output_df_fn = predict_race(voter.file = name_zip_data_fn, census.geo = "county", census.key = "a3cd003810b4773f865433c80467cb94f95860f2", first_name = FALSE)

write.csv(output_df_fn, file = "probability_wo_fn.csv")
