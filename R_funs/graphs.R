ez_graph <- function(loc, df, fun, svg){
    dir.create(loc)

    count = 0 
    for(i in colnames(df)){
        file_name <- paste(loc, '/', 0, count, '_', i, sep='')
        if (count > 9) {file_name <- paste(loc, '/', count, '_', i, sep='')}
        print(file_name)
        count = count + 1
        write_graph(file_name, fun(df, i), svg)
    }
}

# generate a regression plot
gen_regression <- function(df, col) {
    return(
        ggplot(df, mapping=aes_string(x="success", y=col)) +
        geom_point() +
        geom_smooth() + 
        geom_hline(yintercept=0)
    )
}

gen_cat_scatter <- function(df, col){
    ggplot(df, mapping=aes_string(x="success", y=col)) +
        geom_point() +
        geom_hline(yintercept=0)
}

gen_cat_scatter_facet <- function(df, col){
    gen_cat_scatter() +
    

}

write_graph <- function(file_name, graph, web_image){
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
