pretty_print <- function(col){
    # if the cols have been gained through recursion it cuts off all of the routing information and leaves just the final aspect
    remove_dir <- function(col){
        # checks if their are /s
        if(grepl("/", col)){ 
            # splits completely
            col <- str_split(col,"/") 
            # only pulls the last of the of the spllit which would be just the col
            col <- col[[1]][length(col[[1]])]
        }
        
        return(col) # explict return if it doesn't make changes
    }
    # removes .csv from the end of the col
    remove_csv <- function(col){
        # checks to see if csv in is the col name
        if(grepl(".csv", col)){ 
            # if it is it splits in 2
            col <- str_split(col,".csv", 2)
            # pulls the first element (col name) 
            col <- col[[1]][1]
        }
        return(col)
    }
    
    # adds spaces instead of underscores
    add_spaces <- function(col){
        # keeps running while there is an _
        while(grepl("_", col)){
            # replaces
            col <- str_replace(col, "_", " ")
        }
        return(col)
    }

    # adds capitilization to the strings
    add_capitilzation <- function(col){
        # first run through is true so it capitlizes
        found_space <- TRUE
        # string saver
        new_str <- ""
        # splits the word per letter
        for(i in strsplit(col, "")[[1]]){
            # capitilzes after ever space
            if(found_space){
                # appends the capital to the space
                new_str <- paste(new_str, str_to_upper(i), sep="")
                # stands down
                found_space = FALSE
                # `continue` doesn't run the remainder of this loop
                next
            }
            
            # if its found a space force uppercase on next letter
            if(i == " "){
                found_space = TRUE
            }

            # at end paste the string
            new_str <- paste(new_str, i, sep="")
        }

        # force the return
        return(new_str)

    }

    # this order is very important like don't change this
    return(
        add_capitilzation(
            remove_dir(
                remove_csv(
                    add_spaces(
                        col
                    )
                )
            )
        )
    )
}