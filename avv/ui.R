library(shiny)
library(leaflet)
library(RColorBrewer)


ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
               selectInput("anno", "Anno",
                           c(unique(as.character(df$anno))), selected = 2018),
               br(),
               DT::dataTableOutput("tabella")
             )
  
  
  )
