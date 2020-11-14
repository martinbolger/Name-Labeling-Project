## ---------------------------
##
## Name: caller.r
##
## Purpose of script: 
## This script calls the scripts for the name labeling project in order.
##
## Data Sources:
## 
##   
## Author: Martin Bolger
##
## Date Created: 2020.11.07

## set working data directory


## RUN SCRIPTS:
setwd("~/GitHub/Name-Labeling-Project/code/scripts")
code_path = file.path("data_management.R")
source(code_path)

setwd("~/GitHub/Name-Labeling-Project/code/scripts")
code_path = file.path("flag_name_data.R")
source(code_path)

setwd("~/GitHub/Name-Labeling-Project/code/scripts")
code_path = file.path("split_fips.R")
source(code_path)

setwd("~/GitHub/Name-Labeling-Project/code/scripts")
code_path = file.path("create_data_subsets.R")
source(code_path)

setwd("~/GitHub/Name-Labeling-Project/code/scripts")
code_path = file.path("merge_first_name_probabilities.R")
source(code_path)

setwd("~/GitHub/Name-Labeling-Project/code/scripts")
code_path = file.path("call_predict_race.R")
source(code_path)

