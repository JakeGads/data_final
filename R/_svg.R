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
source("str.R")
#endregion

cat_val <- c("category", "main_category", "currency", "state", "country")
colnames(data)
'
 [1] "ID"               "name"             "category"         "main_category"   
 [5] "currency"         "deadline"         "goal"             "launched"        
 [9] "pledged"          "state"            "backers"          "country"         
[13] "usd_pledged"      "usd_pledged_real" "usd_goal_real" 
'

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
get_scatter <- function(df, y){
    print(paste("Generating ", y))
    return(
        ggplot(df,
            aes_string(x="success_factor", y=y, color="usd_goal_real")) + 
        geom_point() + 
        labs(
            x = pretty_print("success_factor"),
            y = pretty_print(y),
            color = pretty_print("usd_goal_real"),
            title=paste("Success Factor vs", pretty_print(y))
        )
    )
}



# ggarrange
data_scatter <- data %>% mutate(success_factor = ((usd_pledged_real+1)/(usd_goal_real + 1))) # we add 1 to elimate the chance of division by < 1 which is multiplication you fucjing dumbass

print("Init")
dir.create("_init")
for(i in cat_val){
    svg(paste("_init/", i, ".svg", sep=""))
    print(get_scatter(data_scatter, i))
    dev.off()
}

print("





")

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
svg(paste("_init_filtered/", "grid", ".svg", sep=""))
plot_grid(
    get_scatter(data_scatter, cat_val[2]), get_scatter(data_scatter, cat_val[3]),
    get_scatter(data_scatter, cat_val[4]), get_scatter(data_scatter, cat_val[5]),
    nrow = 2, ncol = 2
)
dev.off()

svg(paste("_init_filtered/", "grid_smooth", ".svg", sep=""))
plot_grid(
    get_scatter(data_scatter, cat_val[2]), get_scatter(data_scatter, cat_val[3]),
    get_scatter(data_scatter, cat_val[4]), get_scatter(data_scatter, cat_val[5]),
    nrow = 2, ncol = 2
)
dev.off()

#endregion

#region 3 histogram 

get_histogram <- function(df, col, title=""){
    return(
        ggplot(df, aes_string(x=col)) + 
        geom_bar(mapping=aes(color="black", fill="white")) +
        coord_flip() + 
        labs(
            x = pretty_print(col),
            y = pretty_print("Count"),
            title=paste(paste(pretty_print(col), title))
        )
    )
}

data_hist <- data %>% mutate(success_factor = usd_pledged_real/usd_goal_real)

dir.create("_init_hist")
svg(paste("_init_hist/", "grid", ".svg", sep=""))
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

svg(paste("_init_hist/", "grid_rmoutliers", ".svg", sep=""))
plot_grid(
    get_histogram(data_hist, cat_val[2], "Removed Outliers"), get_histogram(data_hist, cat_val[3], "Removed Outliers"),
    get_histogram(data_hist, cat_val[4], "Removed Outliers"), get_histogram(data_hist, cat_val[5], "Removed Outliers"),
    nrow = 2, ncol = 2
)
dev.off()

#endregion

#region 4 heatmap

get_tile <- function(df, x, y, fill){
    return(
        ggplot(df, aes_string(x,y,fill=fill)) +
        geom_tile() +
        labs(
            x = pretty_print(x),
            y = pretty_print(y),
            title=paste(paste(pretty_print(x), "vs", pretty_print(y))),
            subtitle=paste("Colored by", fill)
        )
    )
}

data_heat <- data %>% 
mutate(success_factor = (usd_pledged_real + 1)/(usd_goal_real + 1)) %>%
filter(success_factor < median(success_factor) + (sd(success_factor) * 3)) %>%
filter(success_factor > median(success_factor) - (sd(success_factor) * 3)) %>% 
filter(success_factor < 2.5)

dir.create("_heatmap")
for(i in 2:length(cat_val)){
    for(h in 2:length(cat_val)){
        svg(paste("_heatmap/", cat_val[i], "_x_", cat_val[h], ".svg", sep=""))
        print(paste("_heatmap/", cat_val[i], " x ", cat_val[h], ".svg", sep=""))
        print(get_tile(data_heat, cat_val[i], cat_val[h], "success_factor"))
        dev.off()
    }
}

dir.create("_heatmap_final")
svg("_heatmap_final/grid1.svg")
get_tile(data_heat, "main_category", "currency", "success_factor")
dev.off()
svg("_heatmap_final/grid2.svg")
get_tile(data_heat, "main_category", "state", "success_factor")
dev.off()
svg("_heatmap_final/grid3.svg")
get_tile(data_heat, "country", "state", "success_factor")
dev.off()
svg("_heatmap_final/grid4.svg")
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

get_bubble <- function(df, col){
    ggplot(data_bubble, aes_string("deadline", "success_factor")) +
    geom_jitter(aes_string(col=col, size="backers")) +
    geom_smooth(aes_string(col=col), method="lm", se=F) +
    labs(

    )
}

dir.create("_bubble")
data_bubble <- data %>% 
mutate(success_factor = ((usd_pledged_real+1)/(usd_goal_real + 1))) %>%
filter(success_factor < 2)

for(i in 2:length(cat_val)){
    svg(paste("_bubble/", cat_val[i], ".svg", sep=""))
    print(get_bubble(data_bubble, cat_val[i]))
    dev.off()
}

svg(paste("_bubble/", "grid", ".svg", sep=""))
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

dir.create("label")
svg("label/scat.svg")
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

svg("label/grid.svg")
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

system("python combine.py")
