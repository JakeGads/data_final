ez_graph <- function(loc, df, fun, svg, x="success"){
    dir.create(loc)

    count = 0 
    for(i in colnames(df)){
        file_name <- paste(loc, '/', 0, count, '_', i, sep='')
        if (count > 9) {file_name <- paste(loc, '/', count, '_', i, sep='')}
        print(file_name)
        count = count + 1
        write_graph(file_name, fun(df, i, x), svg)
    }
}

# generate a regression plot
gen_regression <- function(df, col, x="success") {
    return(
        ggplot(df, mapping=aes_string(x=x, y=col)) +
        geom_point() +
        geom_smooth() + 
        geom_hline(yintercept=0)
    )
}

gen_cat_scatter <- function(df, col, x="success"){
    ggplot(df, mapping=aes_string(x=x, y=col)) +
        geom_point() +
        geom_hline(yintercept=0)
}

gen_cat_scatter_facet <- function(df, y, x, wrapped){
    ggplot(df, mapping=aes_string(x=x, y=y)) +
    geom_point() + 
    facet_wrap(as.formula(paste("~", wrapped)))
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
