server <- function(input, output, session) {
  
  
  dx<-reactive({
    avv %>% 
      filter(anno==input$anno, specie==input$specie) %>% 
      group_by(comune) %>% 
      summarise("casi"=n())
  })
  
  lab<-reactive({
    avv %>% 
    filter(anno==input$anno, specie==input$specie) %>%
    group_by(comune, sostanza) %>% 
    summarise("casi"=n())
  })
  
  com<-reactive({
    dx()$comune
    })
  
  output$map <- renderLeaflet({
    
    polycom<-subset(BG, BG@data$NOME_COM %in% com())
    
    polycom@data %>% inner_join(lab(), by=c("NOME_COM"="comune"))
    
    pop<-paste(polycom@data$NOME_COM, polycom@data$casi, polycom@data$sostanza)
    
    leaflet(data=polycom) %>% addTiles() %>% 
      addPolygons(data=polycom, fillColor="navy",color="", fillOpacity = 0.7) %>% 
      addPolygons(data=BG,fill=F, color="gray", weight=1, opacity=1.0) %>% 
      addPolygons(data=provincie, fill=F, color="blue", weight = 2)
  
  })
  
  ploty<-reactive({
    avv %>% 
    mutate("anno"=as.character(anno)) %>% 
    group_by(anno, specie) %>% 
    summarise("casi"=n()) %>% 
    filter(specie==input$specie) %>% 
      data.frame()
    })
  
  output$p<-renderPlot(
    ggplot(ploty(), aes(x = anno, weight = casi)) +
      geom_bar(fill = "navy") + labs(y="N. casi")+
    theme_minimal()
  )

  tab<-reactive(tabella<-avv %>% 
                  filter(anno==input$anno,specie==input$specie) %>% 
                  select(comune, sostanza) %>% 
                  group_by(comune,sostanza) %>% 
                  summarise("N.casi"=n()) %>% 
                  adorn_totals("row"))
  
  output$tabella<-renderDataTable(
    tab(), class = 'cell-border stripe',rownames = FALSE,caption = "casistica per comune e sostanza identificata",
    options=list(dom='t')
  )
}
