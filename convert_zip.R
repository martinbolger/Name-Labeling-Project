library(wru)
library(noncensus)
setwd("~/GitHub/Name Labeling Project")

name_zip_data = read.csv("nameslist.csv")

zip_codes_2017 = read.csv("ZIP-COUNTY-FIPS_2017-06.csv", colClasses=c(ZIP = 'character',STCOUNTYFP = 'character'))


data_len = nrow(name_zip_data)

data("zip_codes")

name_zip_update = cbind(name_zip_data, state = 0, fips = 0)

# name_zip_update$state = as.character(name_zip_update$state)

for (i in c(1:data_len)){
  cur_zip = name_zip_data$zip[i]
  if (nchar(cur_zip) < 4){
    name_zip_update[i, 'state'] = 'no data'
    name_zip_update[i, 'fips'] = 'no data'
    next
  }
  if (nchar(cur_zip) == 4){
    cur_zip = paste("0", cur_zip, sep = "")
  }
  # print(cur_zip)
  # If they are both misssing, make the state and fips code as blank
  if ((nrow(zip_codes_2017[which(zip_codes_2017$ZIP == cur_zip),]) == 0)&(nrow(zip_codes[which(zip_codes$zip == cur_zip),]) == 0)){
    name_zip_update[i, 'state'] = 'no data'
    name_zip_update[i, 'fips'] = 'no data'
    next
  } else if (nrow(zip_codes_2017[which(zip_codes_2017$ZIP == cur_zip),]) > 0){ #If the main df has an entry for the zip code, use it's value
    fips_code = zip_codes_2017[which(zip_codes_2017$ZIP == cur_zip), 'STCOUNTYFP'][1]
    state_a = zip_codes_2017[which(zip_codes_2017$ZIP == cur_zip), 'STATE'][1]
  } else if (nrow(zip_codes_2017[which(zip_codes_2017$ZIP == cur_zip),]) == 0){ #If the first df is blank for this zip, use the other df
    fips_code = zip_codes[which(zip_codes$zip == cur_zip), 'fips'][1]
    state_a = zip_codes[which(zip_codes$zip == cur_zip), 'state'][1]
  }
  if (nchar(fips_code) == 5){
    fips_num = substr(fips_code, 3, nchar(fips_code))
  }
  if (nchar(fips_code) == 4){
    fips_num = substr(fips_code, 2, nchar(fips_code))
  }
  name_zip_update[i, 'state'] = toString(state_a)
  name_zip_update[i, 'fips'] = fips_num
}

write.csv(name_zip_update, file = "name_zip_fips_state_Dec_18.csv")

