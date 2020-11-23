get_data <- function(location){
    data <- 0
    tryCatch(
        {
            data <- read_csv(location)
        }, warning = function(e) {
            print(paste("Downloading ", location, sep= ""))
            data <- (paste(github, location, sep=""))
        }
    )
    return(data)
}
