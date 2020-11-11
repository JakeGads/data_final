smart_loader <- function(package{
    tryCatch({
        library(package)
    },  error = function(e) {
        install.packages(package)
        library(package)
    }
})