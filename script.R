#region works
# denotes weither or not you want to generate svg images (note it is a timely process)
svg_gen = TRUE

#region smart loaders to load or download scripts

smart_package_loader <- function(package, repo="http://cran.rstudio.com"){
    tryCatch({
        library(package, character.only=TRUE)
    },  error = function(e) {
        install.packages(package, repos = repo)
        tryCatch({
                library(package, character.only=TRUE)
            }, error = function(e) {
                print("packages have failed to install please run in interactive mode")        
            })  
    })
}

smart_script_loader <- function(location, repo){
    tryCatch({
            source(location)
        }, wSarning = function(e) {
            print(paste("Downloading ", location, sep= ""))
            source_url(paste(repo, location, sep=""))
        }, error = function(e) {
            print("must use the raw page ie raw.githubusercontent.com, instead of github.com")
        })
}
 
for (i in c("tidyverse", "devtools", "modelr")){
    smart_package_loader(i, "http://ftp.ussg.iu.edu/CRAN/") # on DeSales wifi this has been the best cran mirror to use
}

for (i in c("R_funs/graphs.R", "R_funs/smart_data.R")){
    smart_script_loader(i, "https://raw.githubusercontent.com/gadzygadz/data_final/main/")
}
#endregion

#region Column Information for generating graphs, placed here so VS-code can vibe
'
 [1] "ID"               "name"             "category"         "main_category"   
 [5] "currency"         "deadline"         "goal"             "launched"        
 [9] "pledged"          "state"            "backers"          "country"         
[13] "usd_pledged"      "usd_pledged_real" "usd_goal_real"
'
#endregion

#region configuring the dataframe for regression
df <- get_data("clean_ks.csv") 
df <- df %>%
mutate(usd_pledged_real = usd_pledged_real / 100000) %>%
mutate(usd_goal_real = usd_goal_real / 100000) %>%
mutate(success=usd_pledged_real - usd_goal_real)

ez_graph("_regresion_imgs", df, gen_regression, svg_gen)
#endregion
#endregion


#region catagiorical scatter
# Jake
## After examing all the generated regressions it quickly struck me that a lot of these projects did successed which I felt was shocking at this point I wanted to by how much did they successed by

# We can edit success variable, and testing that over categorical data
df_slim <- df %>%
mutate(success_rating=usd_pledged_real / usd_goal_real) %>% select(usd_pledged_real, usd_goal_real, category, main_category, currency, deadline, state, country, success_rating)
colnames(df_slim)


ez_graph("_categorical_scatter_plots", df_slim, gen_cat_scatter, svg_gen, "success_rating")
#endregion

#region can facet them 

loc <- "_facet_cat_scatter"
dir.create(loc)
count = 0 
for(i in colnames(df)){
    file_name <- paste(loc, '/', 0, count, '_', i, sep='')
    if (count > 9) {file_name <- paste(loc, '/', count, '_', i, sep='')}
    print(file_name)
    count = count + 1
    tryCatch({
        write_graph(file_name, gen_cat_scatter_facet(df_slim, "usd_pledged_real", "usd_goal_real", i), svg)
    }, error = function(e) {
        print(paste("failed", file_name, sep = " "))
    })
}

#endregion