library(shiny)
library(shinydashboard)
library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)
library(rgdal)
library(sp)
library(lubridate)
library(DT)
library(janitor)
library(RColorBrewer)


dati<-gs_title("Avvelenamenti_2")
ds <-gs_read(dati, ws="avv" )
ds<-ds %>% 
  filter(provincia=="BG")
avv<-ds %>% as.tibble() %>% 
  select(nconf,"sample"=materiale,specie,comune,"dtprelievo"='Data del prelievo',"sostanza"=SOSTANZA) %>% 
  mutate_at( "comune", toupper) %>% 
  filter(comune!="NON DEFINITO") %>% 
  mutate(dtprelievo=mdy(dtprelievo)) %>% 
  mutate(anno=year(dtprelievo))

avv$specie[avv$sample=="ESCA/BOCCONE"]<-"ESCA/BOCCONE"


comuni<-readOGR(dsn="shp", layer = "Comuni_2012_polygon")
comuni<-spTransform(comuni, CRS("+proj=longlat +datum=WGS84"))

BG<-subset(comuni, comuni@data$NOME_PRO == "BERGAMO")
BG<-rmapshaper::ms_simplify(BG)

provincie<-readOGR(dsn="shp", layer="Province_2012_polygon")
provincie<-spTransform(provincie, CRS("+proj=longlat +datum=WGS84"))

# com<-avv$comune[avv$anno==input$anno]
# 
# polycom<-subset(BG, BG@data$NOME_COM %in% com)


####centroidi####
#nomecom<-BG@data$NOME_COM
#centroidi<-coordinates(BG)
#bg<-tibble("comune"=as.character(nomecom), "lng"=centroidi[,1], "lat"=centroidi[,2])



#df<-avv %>% inner_join(bg) 




