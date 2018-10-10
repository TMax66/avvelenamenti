library(shiny)
library(leaflet)
library(RColorBrewer)


ui <- navbarPage("Avvelenamenti", id="nav",
                 
                 tabPanel("mappa",
                          div(class="outer",
                              
                              tags$head(
                                # Include our custom CSS
                                includeCSS("styles.css")),
  
  leafletOutput("map",  width="100%", height="100%"),
  absolutePanel(class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 60, left = "auto", right = 30, bottom = "auto",
                width = 400, height = "auto",
                
                h4("O.M.xxx 2012"),
               
                
                
                
                
                selectInput("anno", "Anno",
                           c(unique(as.character(df$anno))), selected = "")#,
              # br(),
               #DT::dataTableOutput("tabella")
             )
  
  
  )),
  tabPanel("risultati"))
