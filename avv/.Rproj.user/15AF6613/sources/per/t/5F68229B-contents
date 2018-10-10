server <- function(input, output, session) {
  
  
  output$map <- renderLeaflet({
    leaflet(data=df %>% 
              filter(anno==input$anno)) %>% addTiles() %>% 
      fitBounds(~min(lng), ~min(lat), ~max(lng), ~max(lat)) %>% 
      addMarkers(~lng, ~lat, label=~paste(comune,specie, sostanza)) %>% 
     
      addPolygons(data=BG, fill=F,color="black",weight = 1,  opacity = 1.0,group = "poly",
                  highlightOptions = highlightOptions(color = "blue", weight = 3,
                  bringToFront = TRUE)) %>% 
      addLayersControl(overlayGroups = "poly")
  })
  
  tab<-reactive(tabella<-df %>% 
                  filter(anno==input$anno) %>% 
                  select(comune, "campione"=specie, sostanza) %>% 
                  group_by(comune,campione,sostanza) %>% 
                  summarise("N.casi"=n()) %>% 
                  adorn_totals("row"))
  
  output$tabella<-renderDataTable(
    tab()
  )
}
