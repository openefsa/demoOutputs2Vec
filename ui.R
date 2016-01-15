library(shiny)
source("tools.R")

shinyUI(
    mainPanel(
        tabsetPanel(
            tabPanel("explore",
                     sidebarLayout(

                                      
                         sidebarPanel(
                             textInput("term","Term:"),
                             sliderInput("numSims",
                                         "# similarities to show",
                                         min = 5,
                                         max = 1000,
                                         value = 10)
                         ),

                                      
                         mainPanel(
                             tableOutput("simTable")
                         )
                     )
                     ),
            tabPanel("arithmetic",
                     sidebarLayout(

                                       
                         sidebarPanel(
                             selectInput("termsAdd","Additive term",top_x,multiple=T),
                             selectInput("termsNeg","Negative term",top_x,multiple=T),
                             
                             sliderInput("numSimsArr",
                                         "# similarities to show:",
                                         min = 5,
                                         max = 1000,
                                         value = 10)
                         ),

                                        # Show a plot of the generated distribution
                         mainPanel(
                             tableOutput("simTableArr")
                         )
                     )
                     ),


            
            tabPanel("Graph",


                     
                     fluidPage(
                         fluidRow(
                             column(4,
                                    selectizeInput("terms","Add term",choices=NULL,multiple=T)) ,
                             column(3,
                                    sliderInput("simTerms","# similarities to show",5,1000,10)
                                    
                                    ),
                             
                             column(3,
                                    sliderInput("opacity","Opacity",0,1,1),
                                    sliderInput("opacityNoHover","Opacity no-hover",0,1,1),
                                    sliderInput("fontsize","Font size",5,30,15)
                                    )) ,
                         fluidRow(
                             
                             column(12,
                                    forceNetworkOutput("force",height="800px")))
                     )
                     

                     ),
            tabPanel("EFSA topics",
                     forceNetworkOutput("forceTopic",height="1024px")
                     
                     )))

)
