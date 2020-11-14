# denotes weither or not you want to generate svg images (note it is a timely process)
svg_gen = F

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
        }, warning = function(e) {
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

#region Column Information for generating graphs
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
mutate(success=usd_pledged_real - usd_goal_real)

ez_graph("_regresion_imgs", df, gen_regression, svg_gen)
#endregion

# region catagiorical scatter
# Jake
## After examing all the generated regressions it quickly struck me that a lot of these projects did successed which I felt was shocking at this point I wanted to by how much did they successed by

# We can edit success variable, and testing that over categorical data
df_slim <- df %>%
mutate(success=usd_pledged_real / usd_goal_real) %>%
select(category, main_category, currency, deadline, state, country, success)

ez_graph("_categorical_scatter_plots", df_slim, gen_cat_scatter, T)
# endregion