library(shiny)
source("tools.R")




shinyServer(function(input, output,session) {
    updateSelectizeInput(session, 'terms', choices = row.names(vectors), server = TRUE)
    graph <- reactive({
        mem_make_graph(input$terms,input$simTerms)
        
    })
    output$force <- renderForceNetwork({
        
        forceNetwork(Links = graph()$links, Nodes = graph()$nodes, Source = "source",
                     Target = "target", Value = "value", NodeID = "name",
                     Group = "group", zoom = TRUE,linkWidth=c(1),
                     legend=TRUE,fontSize = input$fontsize,opacity = input$opacity,
                     linkDistance =
                         JS("function(d){return d.value * 50}"),
                     opacityNoHover = input$opacityNoHover,
                     charge=-200,
                     height=800,
                     width=800
                     )

    })
    output$forceTopic <- renderForceNetwork({
        
        topics <- mem_make_graph(readLines("topics.txt",n=80),10)
        
        forceNetwork(Links = topics$links, Nodes = topics$nodes, Source = "source",
                     Target = "target", Value = "value", NodeID = "name",
                     Group = "group", zoom = TRUE,linkWidth=c(1),
                     legend=TRUE,fontSize = 10,opacity = 0.8,
                     linkDistance =
                         JS("function(d){return d.value * 50}"),
                     opacityNoHover = 1,
                     charge=-200,
                     height=1024,
                     width=1024
                     )

    })
    output$simTable <- renderTable({
        nearests <- mem_nearest_to(vectors,vectors[[input$term]],input$numSims)
        vecs <- data.frame(t(sapply(names(nearests),function(x){vectors[[x]]})))
        
        cbind(nearests=nearests,vecs)
    })

    output$simTableArr <- renderTable({
        sum <- 0
        for (t in input$termsAdd) {
            sum <- sum + vectors[[t]]
        }
        for (t in input$termsNeg) {
            sum <- sum - vectors[[t]]
        }
        
        nearests <- mem_nearest_to(vectors,sum,input$numSimsArr)
        data.frame(nearests) 
    })
    
}




)
