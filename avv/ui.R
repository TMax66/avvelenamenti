library(shiny)
library(leaflet)
library(RColorBrewer)


ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
               # sliderInput("anno", "Anno", 2002, 2018,
                           # value = 2018, step =1)
               selectInput("anno", "Anno",
                           c(unique(as.character(df$anno))), selected = 2018
                )
                
                
                #),
               
  ))
