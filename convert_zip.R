library(wru)
library(noncensus)

name_zip_data = read.csv("nameslist.csv")

data_len = nrow(name_zip_data)

data("zip_codes")

name_zip_update = cbind(name_zip_data, state = 0, fips = 0)

for (i in c(1:data_len)){
  cur_zip = name_zip_data$zip[i]
  print('Zip code')
  if (nchar(cur_zip) < 4){
    name_zip_update[i, 'state'] = 'no data'
    name_zip_update[i, 'fips'] = 'no data'
    next
  }
  if (nchar(cur_zip) == 4){
    cur_zip = paste("0", cur_zip, sep = "")
  }
  if (nrow(zip_codes[which(zip_codes$zip == cur_zip),]) == 0){
    name_zip_update[i, 'state'] = 'no data'
    name_zip_update[i, 'fips'] = 'no data'
    next
  }
  fips_code = zip_codes[which(zip_codes$zip == cur_zip), 'fips']
  state_a = zip_codes[which(zip_codes$zip == cur_zip), 'state']
  print('State')
  print(state_a)
  print(fips_code)
  if (nchar(fips_code) == 5){
    fips_num = substr(fips_code, 3, nchar(fips_code))
  }
  if (nchar(fips_code) == 4){
    fips_num = substr(fips_code, 2, nchar(fips_code))
  }
  print('fips code')
  print(fips_num)
  name_zip_update[i, 'state'] = state_a
  name_zip_update[i, 'fips'] = fips_num
}

write.csv(name_zip_update, file = "name_zip_fips_state.csv")

