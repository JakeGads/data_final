#region Setup
#region Libraries
library(tidyverse)
library(devtools)
library(modelr)
library(ggplot2)
library(scales)
library(cowplot)
#endregion

#region loading 
setwd("~/source/repo/Data_Final/R")
data <- read_csv("clean_ks.csv")
#endregion

#region Scripts
for(i in c("str.R", "regression.R", "graphs.R")){
    source(i)
}
#endregion

cat_val <- c("category", "main_category", "currency", "state", "country")
numeric_vals <- c("goal", "pledged", "backers", "usd_pledged", "usd_pledged_real", "usd_goal_real")
#region ColorBlind friendly mode

library(viridis)
library(scales)

theme_set(theme_minimal())

options(ggplot2.continuous.colour="viridis")
options(ggplot2.continuous.fill = "viridis")
#endregion

#endregion

#region 7 the one that makes the regression

model_data <- data %>% 
mutate(success_factor = (usd_pledged_real + 1)/(usd_goal_real + 1)) %>%
filter(success_factor < median(success_factor) + (sd(success_factor) * 3)) %>%
filter(success_factor > median(success_factor) - (sd(success_factor) * 3))


dir.create('_regression')
dir.create('regression')
print("regression")