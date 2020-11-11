smart_package_loader <- function(package){
    tryCatch({
        library(package, character.only=TRUE)
    },  error = function(e) {
        install.packages(package, repos = "http://ftp.ussg.iu.edu/CRAN/", character.only=TRUE)
        library(package)
    })
}

smart_script_loader <- function(location){
    github <- "https://raw.githubusercontent.com/gadzygadz/data_final/main/"
    tryCatch(
        {
            source(location)
        }, warning = function(e) {
            print(paste("Downloading ", location, sep= ""))
            source_url(paste(github, location, sep=""))
        }
    )
}

for (i in c("tidyverse", "devtools")){
    smart_package_loader(i)
}

for (i in c("R_funs/graphs.R", "R_funs/smart_data.R")){
    smart_script_loader(i)
}

df <- get_data("clean_ks.csv")

