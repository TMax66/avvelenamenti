server <- function(input, output, session) {
  
  
  dx<-reactive({
    avv %>% 
      filter(anno==input$anno, specie==input$specie) %>% 
      group_by(comune) %>% 
      summarise("casi"=n())
  })
  
  com<-reactive({
    dx()$comune
    })
  
  output$map <- renderLeaflet({
    
    polycom<-subset(BG, BG@data$NOME_COM %in% com())
    
    polycom@data %>% inner_join(dx(), by=c("NOME_COM"="comune"))
    
    pop<-paste0(polycom@data$NOME_COM, 
           dx()$casi)
    
    leaflet(data=polycom) %>% addTiles() %>% 
      addPolygons(data=polycom, fillColor="navy",color="", fillOpacity = 0.7) %>% 
      addPolygons(data=BG,fill=F, color="gray", weight=1, opacity=1.0) %>% 
      addPolygons(data=provincie, fill=F, color="blue", weight = 2)
  
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
