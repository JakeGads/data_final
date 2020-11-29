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


get_bubble <- function(df, col){
    ggplot(data_bubble, aes_string("deadline", "success_factor")) +
    geom_jitter(aes_string(col=col, size="backers")) +
    geom_smooth(aes_string(col=col), method="lm", se=F) +
    labs(

    )
}