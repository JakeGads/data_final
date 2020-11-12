# generate a regression plot
gen_regression <- function(df, col) {
    return(
        ggplot(df, mapping=aes_string(x="success", y=col)) +
        geom_point() +
        geom_smooth() + 
        geom_hline(yintercept=0)
    )
}

write_graph <- function(location, graph, web_image){
    if(!file.exists(paste(file_name, '.png',sep = ""))){
        png(paste(file_name, '.png', sep=''))
        print(graph)
        dev.off()
    }
    else {
       print("  Already Generated PNG, to regen please clear data")
    }
    if(web_image && !file.exists(paste(file_name, '.svg',sep = ""))){
        svg(paste(file_name, '.svg', sep=''))
        print(graph)
        dev.off()
    }
    else {
       print("  Already Generated SVG, to regen please clear data")
    }
}
