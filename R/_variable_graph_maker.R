file_type <- c(png, ".png") # swap this if you change the output type

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

#region exploration

#region 1 Map Maybe?, we'll see
#endregion

#region 1 & 2
# ggarrange
data_scatter <- data %>% mutate(success_factor = ((usd_pledged_real+1)/(usd_goal_real + 1))) # we add 1 to elimate the chance of division by < 1 which is multiplication you fucjing dumbass

print("Init")
dir.create("_init")
for(i in cat_val){
    file_type[[1]](paste("_init/", i, file_type[[2]], sep=""))
    print(get_scatter(data_scatter, i))
    dev.off()
}


print("Filtered Outliers")
# lets try to filter a little, and throw out the useless one
data_scatter <- data_scatter %>% 
    filter(
        success_factor > (median(success_factor) - (sd(success_factor) * 3 ))
    ) %>%
    filter(
        success_factor < (median(success_factor) + (sd(success_factor) * 3 ))
    )
dir.create("_init_filtered")
file_type[[1]](paste("_init_filtered/", "grid", file_type[[2]], sep=""))
plot_grid(
    get_scatter(data_scatter, cat_val[2]), get_scatter(data_scatter, cat_val[3]),
    get_scatter(data_scatter, cat_val[4]), get_scatter(data_scatter, cat_val[5]),
    nrow = 2, ncol = 2
)
dev.off()

file_type[[1]](paste("_init_filtered/", "grid_smooth", file_type[[2]], sep=""))
plot_grid(
    get_scatter(data_scatter, cat_val[2]), get_scatter(data_scatter, cat_val[3]),
    get_scatter(data_scatter, cat_val[4]), get_scatter(data_scatter, cat_val[5]),
    nrow = 2, ncol = 2
)
dev.off()

#endregion

#region 3 histogram

data_hist <- data %>% mutate(success_factor = usd_pledged_real/usd_goal_real)

dir.create("_init_hist")
file_type[[1]](paste("_init_hist/", "grid", file_type[[2]], sep=""))
plot_grid(
    get_histogram(data_hist, cat_val[2]), get_histogram(data_hist, cat_val[3]),
    get_histogram(data_hist, cat_val[4]), get_histogram(data_hist, cat_val[5]),
    nrow = 2, ncol = 2
)
dev.off()

data_hist <- data_hist %>% 
filter(
    success_factor > (median(success_factor) - (sd(success_factor) * 3 ))
) %>%
filter(
    success_factor < (median(success_factor) + (sd(success_factor) * 3 ))
)

file_type[[1]](paste("_init_hist/", "grid_rmoutliers", file_type[[2]], sep=""))
plot_grid(
    get_histogram(data_hist, cat_val[2], "Removed Outliers"), get_histogram(data_hist, cat_val[3], "Removed Outliers"),
    get_histogram(data_hist, cat_val[4], "Removed Outliers"), get_histogram(data_hist, cat_val[5], "Removed Outliers"),
    nrow = 2, ncol = 2
)
dev.off()

#endregion

#region 4 heatmap

data_heat <- data %>% 
mutate(success_factor = (usd_pledged_real + 1)/(usd_goal_real + 1)) %>%
filter(success_factor < median(success_factor) + (sd(success_factor) * 3)) %>%
filter(success_factor > median(success_factor) - (sd(success_factor) * 3)) %>% 
filter(success_factor < 2.5)

dir.create("_heatmap")
for(i in 2:length(cat_val)){
    for(h in 2:length(cat_val)){
        file_type[[1]](paste("_heatmap/", cat_val[i], "_x_", cat_val[h], file_type[[2]], sep=""))
        print(paste("_heatmap/", cat_val[i], " x ", cat_val[h], file_type[[2]], sep=""))
        print(get_tile(data_heat, cat_val[i], cat_val[h], "success_factor"))
        dev.off()
    }
}

dir.create("_heatmap_final")
file_type[[1]]("_heatmap_final/grid1.png")
get_tile(data_heat, "main_category", "currency", "success_factor")
dev.off()
file_type[[1]]("_heatmap_final/grid2.png")
get_tile(data_heat, "main_category", "state", "success_factor")
dev.off()
file_type[[1]]("_heatmap_final/grid3.png")
get_tile(data_heat, "country", "state", "success_factor")
dev.off()
file_type[[1]]("_heatmap_final/grid4.png")
get_tile( data_heat, "country", "main_category", "success_factor")
dev.off()
#endregion

#region 5 Swole boy hours

'
 [1] "ID"               "name"             "category"         "main_category"   
 [5] "currency"         "deadline"         "goal"             "launched"        
 [9] "pledged"          "state"            "backers"          "country"         
[13] "usd_pledged"      "usd_pledged_real" "usd_goal_real" 
'

dir.create("_bubble")
data_bubble <- data %>% 
mutate(success_factor = ((usd_pledged_real+1)/(usd_goal_real + 1))) %>%
filter(success_factor < 2)

for(i in 2:length(cat_val)){
    file_type[[1]](paste("_bubble/", cat_val[i], file_type[[2]], sep=""))
    print(get_bubble(data_bubble, cat_val[i]))
    dev.off()
}

file_type[[1]](paste("_bubble/", "grid", file_type[[2]], sep=""))
plot_grid(
    get_bubble(data_bubble, cat_val[2]), get_bubble(data_bubble, cat_val[3]), 
    get_bubble(data_bubble, cat_val[4]), get_bubble(data_bubble, cat_val[5]),
    nrow=2, ncol=2 
)
dev.off()

#endregion

#region 6 the one that zooms
data_zoom <- data %>% 
filter(state == "successful") %>%
filter(usd_pledged_real < mean(usd_pledged_real) + (sd(usd_pledged_real) * 3)) %>%
filter(usd_pledged_real > mean(usd_pledged_real) - (sd(usd_pledged_real) * 3)) %>%
filter(usd_goal_real < mean(usd_goal_real) + (sd(usd_goal_real) * 3)) %>%
filter(usd_goal_real > mean(usd_goal_real) - (sd(usd_goal_real) * 3)) 

top <- data_zoom %>% arrange(desc(usd_pledged_real))
top <- top[1,] # 475193.7 15000

bottom <- data_zoom %>% arrange(usd_pledged_real)
bottom <- bottom[1,] # .79 .79

dir.create("_label")
file_type[[1]]("_label/scat.png")
ggplot(data_zoom,  aes(x=usd_pledged_real, y=usd_goal_real, color=main_category)) + 
geom_point() + 
labs(
    x = pretty_print("usd_pledged_real"),
    y = pretty_print("usd_goal_real"),
    color = pretty_print("main_category"),
    title=paste(pretty_print("pledged"), "vs", pretty_print("goal"), " Successful")
) + geom_label(
    aes(label=top[2]),
    top
) + geom_label(
    aes(label=bottom[2]),
    bottom
)
dev.off()

file_type[[1]]("_label/grid.png")
plot_grid(
    ggplot(data_zoom,  aes(x=usd_pledged_real, y=usd_goal_real, color=main_category)) + 
    geom_point() + 
    labs(
        x = pretty_print("usd_pledged_real"),
        y = pretty_print("usd_goal_real"),
        color = pretty_print("main_category"),
        title=paste(pretty_print("pledged"), "vs", pretty_print("goal"), " Successful")
    ) + geom_label(
        aes(label=top[2]),
        top
    ) + geom_label(
        aes(label=bottom[2]),
        bottom
    ) + theme(legend.position = "none"),
    ggplot(data_zoom,  aes(x=usd_pledged_real, y=usd_goal_real, color=main_category)) + 
    geom_point(show.legend = FALSE) + 
    labs(
        x = pretty_print("usd_pledged_real"),
        y = pretty_print("usd_goal_real"),
        color = pretty_print("main_category"),
        title=paste(pretty_print("pledged"), "vs", pretty_print("goal"), " Successful")
    ) + geom_label(
        aes(label=top[2]),
        top
    ) + geom_label(
        aes(label=bottom[2]),
        bottom
    ) + coord_cartesian(
        ylim=c(14990, 15100),
        xlim=c(475183, 475203)
    ) + theme(legend.position = "none"),
    ggplot(data_zoom,  aes(x=usd_pledged_real, y=usd_goal_real, color=main_category)) + 
    geom_point(show.legend = FALSE) + 
    labs(
        x = pretty_print("usd_pledged_real"),
        y = pretty_print("usd_goal_real"),
        color = pretty_print("main_category"),
        title=paste(pretty_print("pledged"), "vs", pretty_print("goal"), " Successful")
    ) + geom_label(
        aes(label=top[2]),
        top
    ) + geom_label(
        aes(label=bottom[2]),
        bottom
    ) + coord_cartesian(
        ylim=c(.69, .89),
        xlim=c(.69, .89)
    ) + theme(legend.position = "none"),
    ncol=1,nrow=3
)
dev.off()
#endregion

#region 7 the one that makes the regression

model_data <- data %>% 
mutate(success_factor = (usd_pledged_real + 1)/(usd_goal_real + 1)) %>%
filter(success_factor < median(success_factor) + (sd(success_factor) * 3)) %>%
filter(success_factor > median(success_factor) - (sd(success_factor) * 3))


dir.create('_regression')
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
    for(j in 1:length(c(
        loess(y ~ x, new_data),
        loess(y ~ I(x^2), new_data),
        loess(log(y) ~ sqrt(x) - 1, new_data),
        loess(y ~ I(x^2) + x - 1, new_data)
        )
    )){
	    print(paste("loess", titles[j]))
        gen_model(
            new_data,
            linear_model[j],
            paste("Loess Model:", titles[j], sep=" "),
            pretty_print(i),
            pretty_print("success_factor"),
            paste("regression/Loess", pretty_print(i), "x", titles[j]),
            TRUE,
            25
        )
    }
    print("loping linear")
    for(j in 1:length(c(
        lm(y ~ x, new_data),
        lm(y ~ I(x^2), new_data),
        lm(log(y) ~ sqrt(x) - 1, new_data),
        lm(y ~ I(x^2) + x - 1, new_data)
    ))){
	print(paste("linear", title[j]))
        gen_model(
            new_data,
            linear_model[j],
            paste("Linear Model:", titles[j], sep=" "),
            pretty_print(i),
            pretty_print("success_factor"),
            pretty_print("regression/", i),
            TRUE,
            25
        )
    }
}

#endregion
system("python combine.py")
