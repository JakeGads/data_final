
#' Runs a full regression test and saves the information to a pdf if requested
#' @param df (tibble) containg value1 and value2 where value1 is the X and value2 is the Y
#' @param regression (object) the regression algoirthm alread applied to the 
#' @param regression_formula_str (string) the formula as a string for labs
#' @param val1_str (string) the string that represents value 1
#' @param val2_Str (string) the string that represents value 2
#' @param pdf (string) when set this will save the graphs as that file name
#' @param smooth_comp (bool) if set to True will add a geom smooth to each approapriate graph in a grid
#' @export a joined, cleaned and pivioted tibble
gen_model <- function(df, regression, regression_formula_str='A regression Model', val1_str="X", val2_str="Y", pdf='', smooth_comp=F, bins=10){
    # create the pdf file if a file name was given
    if(pdf != ''){
        pdf(paste(pdf, ".pdf", sep=""))
    }

    grid <- df %>%
    data_grid(x) %>%
    add_predictions(regression)


    # create the first plot
    plot1 <- ggplot(df, aes(x)) + 
        geom_point(aes(y=y)) +
        geom_point(data = grid, aes(y=pred), color="orange") + # orange was chosen to be color-blind friendlier
        labs( # labs
            title = paste(regression_formula_str, " Intial", sep=""),
            subtitle = paste(val1_str, " vs ", val2_str, sep=""),
            x = val1_str,
            y = val2_str
        )
    
    dir.create("pics")
    png(paste("pics/", pdf, "-", 1, ".png", sep = ""))
    print(plot1)
    dev.off()

    if(smooth_comp){ # if they want a comparson
        # generate a second fraph with the 2nd point replaced with a smooth
        secondary <- ggplot(df, aes(x)) + 
            geom_point(aes(y=y)) +
            geom_smooth(data = grid, aes(y=pred), color="orange") + # leave that orange color
            ggtitle(title) +
            labs(
                title = paste("Smooth Compare 1", sep=""),
                subtitle = paste(val1_str, " vs ", val2_str, sep=""),
                x = val1_str,
                y = val2_str
            )
        
        plot1 <- grid.arrange( # overwrite plot with a grid of the both plots
            plot1, # our intial plot
            secondary, # our secondary plot
            nrow=1
        )
    }

    print(
        plot1 # prints, if set to a pdf it will print there else it will use whatever output method is available
    )

    df <- df %>%
    add_residuals(regression) # adding some regression to out dataframe

    bin <- (max(df$resid) - min(df$resid)) / bins # calcualtes the bin sizes based on the amount of bins you've asked for

    plot2 <- ggplot(df, aes(resid)) + # plotting the residual regression
        geom_freqpoly(binwidth=bin) +
        ggtitle(title) +
        labs(
            title = paste(regression_formula_str, " Residuals", sep=""),
            subtitle = paste(val1_str, " vs ", val2_str, " with ", bins, " bins",sep=""),
            x = "Residual",
            y = "Count",
            caption=paste("With a bin size of", round(bin,2), sep = " ")
        )
    dir.create("pics")
    png(paste("pics/", pdf, "-", 2, ".png", sep = "")) 
    print(plot2)
    dev.off()
    
    print( # see last print
       plot2
    )
    

    # graphing against the residual
    plot3 <- ggplot(df, aes(x,resid)) +
        geom_point() +
        geom_ref_line(h=0) +
        ggtitle(title) +
        labs(
            title = paste(regression_formula_str, " Residual Test", sep=""),
            subtitle = paste(val1_str, " vs ", val2_str, sep=""),
            x = val1_str,
            y = val2_str
        )

    png(paste("pics/", pdf, "-", 3, ".png", sep=""))
    print(plot3)
    dev.off()


    if(smooth_comp){ # including the comparision
        secondary <- ggplot(df, aes(x,resid)) +
        geom_smooth() + 
        geom_ref_line(h=0) +
        ggtitle(title) +
        labs(
            title = paste(regression_formula_str, " Residual Test Geom_Smooth Comparison", sep=""),
            subtitle = paste(val1_str, " vs ", val2_str, sep=""),
            x = val1_str,
            y = val2_str
        )

        plot3 <- grid.arrange(
            plot3,
            secondary,
            nrow=2
        )
    }

    print(
        plot3
    )

    if(pdf != ''){ # if a pdf was selected it will now shutdown the outfile and save it
        dev.off()
    }
}
