server <- function(input, output, session) {
  
  
  com<-reactive({avv$comune[avv$anno==input$anno]})
  
  
  output$map <- renderLeaflet({
    
    polycom<-subset(BG, BG@data$NOME_COM %in% com())
    
    leaflet(data=polycom) %>% addTiles() %>% 
      addPolygons(data=polycom, fillColor="red",color="black",weight = 1) %>% 
      addPolygons(data=BG,fill=F, color="gray", weight=1, opacity=1.0)
  
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
