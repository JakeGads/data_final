library(tidyverse)
library(devtools)
library(modelr)
setwd("~/source/repo/data_final/R")
data <- read_csv("clean_ks.csv")

colnames(data)
'
 [1] "ID"               "name"             "category"         "main_category"   
 [5] "currency"         "deadline"         "goal"             "launched"        
 [9] "pledged"          "state"            "backers"          "country"         
[13] "usd_pledged"      "usd_pledged_real" "usd_goal_real" 
'

