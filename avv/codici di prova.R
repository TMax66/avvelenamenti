library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)
library(rgdal)
library(sp)
library(lubridate)
library(janitor)

rm(list=ls())
dati<-gs_title("avvelenamenti")
ds <-gs_read(dati, ws="avv" )

avv<-ds %>% as.tibble() %>% 
  select(id,nconf,"sample"=materiale,specie,comune,"dtprelievo"='Data del prelievo',"sostanza"=SOSTANZA) %>% 
  mutate_at( "comune", toupper) %>% 
  filter(comune!="NON DEFINITO") %>% 
  mutate(dtprelievo=mdy(dtprelievo)) %>% 
  mutate(anno=year(dtprelievo))
avv$specie[avv$sample=="ESCA/BOCCONE"]<-"ESCA/BOCCONE"
avv<-avv %>% 
  filter(anno==2014, specie=="CANE") %>% 
  group_by(comune) %>% 
  summarise("casi"=n())
com<-avv$comune






comuni<-readOGR(dsn="shp", layer = "Comuni_2012_polygon")
comuni<-spTransform(comuni, CRS("+proj=longlat +datum=WGS84"))

BG<-subset(comuni, comuni@data$NOME_PRO == "BERGAMO")
BG<-rmapshaper::ms_simplify(BG)


polycom<-subset(BG, BG@data$NOME_COM %in% com)
polycom@data<polycom@data %>% inner_join(avv, by=c("NOME_COM"="comune"))

bins <- c(1,2,3)
pal <- colorBin("YlOrRd", domain = x, bins = bins)


leaflet(data=polycom) %>% addTiles() %>% 
  #questo aggiunge il layer dei comuni con casi di avv filtrati per input$anno#
  addPolygons(data=polycom, fillColor = ~pal(x),color="black",weight = 3) %>% 
  addPolygons(data=BG,fill=F, color="black", weight=1, opacity=1.0)




















BG@data %>% inner_join(avv, by=c("NOME_COM"="comune"))

nomecom<-BG@data$NOME_COM
centroidi<-coordinates(BG)
bg<-tibble("comune"=as.character(nomecom), "lng"=centroidi[,1], "lat"=centroidi[,2])
bg<-bg %>% 
  # mutate("lng"=jitter(lng, factor=0.0001), "lat"=jitter(lat, factor=0.0001))

# leaflet(data=bg) %>% addTiles() %>% 
#   addMarkers(~lng, ~lat,popup = ~as.character(comune), label = ~as.character(comune))


BG@data<-merge(BG@data, avv, by.x="NOME_COM", by.y="comune", all.x=TRUE)

BG@data<-BG@data %>% left_join(avv, by=c("NOME_COM"="comune"))

df<-avv %>% inner_join(bg) 
df$specie[df$sample=="ESCA/BOCCONE"]<-"ESCA/BOCCONE"



df %>% 
  filter(anno==2014) %>% 
  select(comune, "campione"=specie, sostanza) %>% 
  group_by(comune,campione,sostanza) %>% 
  summarise("N.casi"=n()) %>% 
  adorn_totals("row")
