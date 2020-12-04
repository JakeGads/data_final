#region Setup
#region Libraries
library(tidyverse)
library(devtools)
library(modelr)
library(ggplot2)
library(scales)
library(cowplot)
library(gridExtra)
library(grid)
#endregion

#region loading 
setwd("~/source/repo/Data_Final/R")
data <- read_csv("clean_ks.csv")
#endregion

#region Scripts
for(i in c("str.R", "regression.R", "graphs.R")){
  source(i)
}

model_data <- data %>% 
  mutate(success_factor = (usd_pledged_real + 1)/(usd_goal_real + 1)) %>%
  filter(success_factor < median(success_factor) + (sd(success_factor) * 3)) %>%
  filter(success_factor > median(success_factor) - (sd(success_factor) * 3)) %>%
  sample_n(10000)

dir.create('_regression')
dir.create('regression')
dir.create("regression_pics")
dir.create("regression_pics/_regression")
new_data <- tibble(
  x = model_data[["backers"]],
  y = model_data[["success_factor"]]
) %>% na.omit(x,y)

grid <- new_data %>%
  data_grid(x) %>%
  add_predictions(lm(y ~ I(x^2) + x - 1, new_data))

gen_model(
  new_data,
  grid,
  lm(y ~ I(x^2) + x - 1, new_data),
  paste("Loess Model:", "lm(y ~ I(x^2) + x - 1, new_data))", sep=" "),
  "Backers",
  "success_factor",
  paste("_regression/LM", "Backers", "x", "Success Factor"),
  TRUE,
  30
)