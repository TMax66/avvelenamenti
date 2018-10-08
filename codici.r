library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)



dati<-gs_title("avvelenamenti")
ds <-gs_read(dati, ws="avv" )

###############################

leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))
IT<-map('italy', fill = TRUE, col = 1:10)
