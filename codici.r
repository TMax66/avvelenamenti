library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)
library(rgdal)
library(sp)


dati<-gs_title("avvelenamenti")
ds <-gs_read(dati, ws="avv" )

###############################

leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))
IT<-map('italy', fill = TRUE, plot=FALSE)


leaflet(data = IT) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

m <- leaflet() %>% setView(lng = 9.6320701, lat =45.693177, zoom = 9)
m %>% addTiles()

bg<-readOGR(dsn="shp", layer = "Comuni_2012_polygon")
bg<-spTransform(bg, CRS("+proj=longlat +datum=WGS84"))
centroidi<-coordinates(bg)
points(centroidi, col="black", pch=20)


####################

london <- readOGR(dsn = "london", layer = "london_sport")
london<-spTransform(london, CRS("+proj=longlat +datum=WGS84"))
