name_zip_data = read.csv("name_zip_fips_state.csv")

name_zip_data$name

name_split = str_split_fixed(name_zip_data$name, ' ', 2)

separate(name_zip_data, name, into = c("first", "Last"), sep = " (?=[^ ]$)")

name_split[,1]

           