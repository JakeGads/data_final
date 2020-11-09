# generate a regression plot
gen_regression <- function(df, col) {
    return(
        ggplot(df, mapping=aes_string(x="sucess", y=col)) +
        geom_scatter() +
        geom_smooth()
    )
}