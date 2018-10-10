library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)
library(rgdal)
library(sp)
library(lubridate)
library(DT)

rm(list=ls())
dati<-gs_title("avvelenamenti")
ds <-gs_read(dati, ws="avv" )

avv<-ds %>% as.tibble() %>% 
  select(id,nconf,"sample"=materiale,specie,comune,"dtprelievo"='Data del prelievo',"sostanza"=SOSTANZA) %>% 
  mutate_at( "comune", toupper) %>% 
  filter(comune!="NON DEFINITO") %>% 
  mutate(dtprelievo=mdy(dtprelievo)) %>% 
  mutate(anno=year(dtprelievo))


comuni<-readOGR(dsn="shp", layer = "Comuni_2012_polygon")
comuni<-spTransform(comuni, CRS("+proj=longlat +datum=WGS84"))

BG<-subset(comuni, comuni@data$NOME_PRO == "BERGAMO")
nomecom<-BG@data$NOME_COM
centroidi<-coordinates(BG)
bg<-tibble("comune"=as.character(nomecom), "lng"=centroidi[,1], "lat"=centroidi[,2])



df<-avv %>% inner_join(bg) 
df$specie[df$sample=="ESCA/BOCCONE"]<-"ESCA/BOCCONE"



