#region Setup
#region Libraries
library(tidyverse)
library(devtools)
library(modelr)
library(ggplot2)
library(scales)
library(cowplot)
#endregion

options(error = function() traceback(10))

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
filter(success_factor > median(success_factor) - (sd(success_factor) * 3)) %>%
arrange(name) %>%
top_n(1000)


dir.create('_regression')
dir.create('regression')
print("regression")
for(i in numeric_vals){
    print(i)
    new_data <- tibble(
        x = model_data[[i]],
        y = model_data[["success_factor"]]
    ) %>% na.omit(z,y)
    print("made tibble")
    titles <- c(
        paste(pretty_print("success_factor"), "~", pretty_print(i),  sep = " "),
        paste(pretty_print("success_factor"), "~I(", pretty_print(i), "squared)", sep = " "),
        paste("log(", pretty_print("success_factor"), ")~", pretty_print(i),  sep = " ", " "),
        paste(pretty_print("success_factor"), "~I(", pretty_print(i), "squared) +", pretty_print(i), "- 1", sep = " ", " ")
    )
    
    print("looping loess")
        models <- c()
        i <- 1
        tryCatch({
            models[i] <- loess(y ~ x, new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })
        tryCatch({
            models[i] <- loess(y ~ I(x^2), new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })
        tryCatch({
            models[i] <- loess(log(y) ~ sqrt(x) - 1, new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })
        tryCatch({
            models[i] <- loess(y ~ I(x^2) + x - 1, new_data)
            i = i + 1
        }, error = function(x) {
            print(x)
        })

        for(j in 1:length(models))
        {
            grid <- new_data %>%
            data_grid(x) %>%
            add_predictions(models[j]) %>%
            na.omit(regression)
            print(paste("loess", titles[j]))
            tryCatch({
                gen_model(
                    new_data,
                    grid,
                    models[j],
                    paste("Loess Model:", titles[j], sep=" "),
                    i,
                    "success_factor",
                    paste("_regression/Loess", i, "x", titles[j]),
                    TRUE,
                    25
                )
            },
            error = function(cond){
                print(cond)
            })
            
        }
        print("loping linear")
        models <- c()
        i <- 1;
        tryCatch({
            models[i] <- lm(y ~ x, new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })
        tryCatch({
            models[i] <- lm(y ~ I(x^2), new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })
        tryCatch({
            models[i] <- lm(log(y) ~ sqrt(x) - 1, new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })
        tryCatch({
            models[i] <- lm(y ~ I(x^2) + x - 1, new_data)
            i = i + 1
        }, error = function(x) {
            print("oof")
        })

        for(j in 1:length(models)){
            print(paste("linear", titles[j]))
            tryCatch({
                gen_model(
                    new_data,
                    models[j],
                    paste("Linear Model:", titles[j], sep=" "),
                    i,
                    "success_factor",
                    paste("_regression/", i, "x", titles[j]),
                    TRUE,
                    25
                )
            },
            error=function(x) {
                print(x)
            })
            
        }
    
}

