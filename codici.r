library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)
library(rgdal)
library(sp)


dati<-gs_title("avvelenamenti")
ds <-gs_read(dati, ws="avv" )

avv<-ds %>% as.tibble() %>% 
  select(id,nconf,"sample"=materiale,specie,comune,"dtprelievo"='Data del prelievo',"sostanza"=SOSTANZA) %>% 
  mutate_at( "comune", toupper) %>% 
  filter(comune!="NON DEFINITO")


comuni<-readOGR(dsn="shp", layer = "Comuni_2012_polygon")
comuni<-spTransform(comuni, CRS("+proj=longlat +datum=WGS84"))

BG<-subset(comuni, comuni@data$NOME_PRO == "BERGAMO")
nomecom<-BG@data$NOME_COM

centroidi<-coordinates(BG)
bg<-tibble("comune"=nomecom, "lng"=centroidi[,1], "lat"=centroidi[,2])


df<-avv %>% inner_join(bg) 

###############################

#m <- leaflet() %>% setView(lng = 9.6320701, lat =45.693177, zoom = 9)
#m %>% addTiles()
leaflet(data=df) %>% addTiles() %>% 
  addMarkers(~lng, ~lat,popup = ~as.character(comune), label = ~as.character(comune))




####################

london <- readOGR(dsn = "london", layer = "london_sport")
london<-spTransform(london, CRS("+proj=longlat +datum=WGS84"))
