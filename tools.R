library(wordVectors)
library(networkD3)
library(dplyr)
library(memoise)



filename <- "efsa_ops_tri_vectors.gz"

guess_n_cols <- function() {
                                        # if cols is not defined
    test = read.table(filename,header=F,skip=1,
                      nrows=1,quote="",comment.char="")
    return(ncol(test)-1)
}


nodesOf <- function(term,all_nodes,all_links,num_terms) {
    print(term)
    nearests <- mem_nearest_to(vectors,vectors[[term]],num_terms)
    if (any(is.na(nearests))){
        return(NA)
    }
    node_names<- unique(c(all_nodes$name,names(nearests)))
    links <-  tbl_df(data.frame(source=c(term),
                               target_names=names(nearests),
                               target=names(nearests),
                               value=unname(nearests),
                               stringsAsFactors = F
                               ))

    links$source <-  sapply(links$source,function(x) {which(node_names== x)-1})
    links$target <-  sapply(links$target,function(x) {(which(node_names== x)-1)[1]})

    links <- rbind(all_links,links)
    
    nodes <- tbl_df( data.frame(name=node_names,stringsAsFactors = F))
    nodes$group <- sapply(nodes$name,function(x) {
        i1 <- (which(nodes$name == x)[[1]])-1
        i2 <- which(links$target==i1)[[1]]
        node_names[links$source[i2]+1]
    })
    

    
    list(links=links,nodes=nodes)
}


make_graph <- function(terms,simTerms) {

    all_nodes <- data.frame()
    all_links <- data.frame()

    
    for (term in terms) {

        result <- mem_nodesOf(term,all_nodes,all_links,simTerms)
        if (any(is.na(result)))
            break;
        all_nodes <- result$nodes
        all_links <- result$links
        
    }
    list(nodes=all_nodes,links=all_links)
}


if (! "vectors" %in% ls()) {
   
    cat("start openning vector file ...\n")
    mem_nearest_to <- memoise(nearest_to)
    mem_read.vectors <-  memoise(read.vectors)
    mem_nodesOf <-  memoise(nodesOf)
    mem_make_graph <- memoise(make_graph)

    vectors <- mem_read.vectors(filename)
    top_x <- sort(row.names(vectors)[1:10000])
    cat("end openning vector file ...\n")
}
plotWv <- function(x) {
    message("Attempting to use T-SNE to plot the vector representation")
    message("Cancel if this is taking too long")
    message("Or run 'install.packages' tsne if you don't have it.")
    x = as.matrix(x)
    short = x[1:min(100,nrow(x)),]
    m = tsne::tsne(short)
    plot(m,type='n',main="A two dimensional reduction of the vector space model using t-SNE")
    text(m,rownames(short),cex = ((400:1)/200)^(1/3))
    rownames(m)=rownames(short)
    silent = m
}
