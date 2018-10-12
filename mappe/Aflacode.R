require(RColorBrewer)
require(Hmisc)
require(epitools)
require(survival)
require(spdep)
require(maptools)
require(maps)
require(mapdata)R
require(xtable)
require(ggplot2)
require(rgdal)
require(gpclib)
require(geoR)
require(lattice)
require(fields)
require(googleVis)
require(rmeta)
require(ggmap)
library(mapproj)
library(rgeos)
library(MapGAM)
rm(list=ls())          

################DATI###################################

df<-read.csv("AflaM1.csv", header=TRUE, sep=';', dec=',')
df<-subset(df, !is.na(df$conf))#ho tolto tutti i record di coord che non hanno un corrispondente in df



df<-aggregate(df$M1, list("codaz"=df$codaz, "anno"=df$anno), mean)
names(df)[3]<-"M1"

coord<-read.csv("coordinate.csv", header=TRUE, sep=';', dec=',')
coord$codaz<-factor(substr(coord$codaz, 1, 8))

coord<-aggregate(coord$hsize, list("codaz"=coord$codaz, "lat"=coord$lat, "lon"=coord$lon, "nord"=coord$nord, "est"=coord$est), sum)
names(coord)[6]<-"hsize"
df<-merge(df,  coord, by="codaz", all.x=TRUE)




######################MAPPE###################################
com<-readShapePoly("Comuni_2016_poligonali_polygon.shp")
proj4string(com)<-"+proj=utm +zone=32 +ellps=WGS84 +units=m +no_defs"
comBG<-subset(com, NOME_PRO == "BERGAMO")
comBG<-spTransform(comBG, CRS("+proj=longlat +ellps=WGS84"))
map <- get_map(location = "Bergamo ", zoom = 10, color="bw")
#BGmap<-ggmap(map)
comBGFort<-fortify(comBG)
#BGmap+geom_polygon(data=comBGFort, aes(x=long, y=lat, group=id), 
                   #alpha=.5, col=1, fill="lightyellow")
newcent<-gCentroid(comBG)
map2<-get_map(as.data.frame(newcent), zoom=9, color = "bw", maptype = "satellite")
BGmap2<-ggmap(map2)
#BB<-bbox(comBG)
BGmap2+geom_polygon(data=comBGFort, aes(x=long, y=lat, group=id), 
                    alpha=.5, col=1, fill="lightyellow")+
  coord_map( xlim=c(9.35,10.30), ylim=c(45.35,46.20))



ggplot()+geom_polygon(data=comBGFort, aes(x=long, y=lat, group=id), alpha=.5, color="black", fill="grey80")+
  coord_map( xlim=c(9.35,10.30), ylim=c(45.35,46.20))+facet_wrap(~anno)+theme_bw()+
  scale_alpha_continuous(range=c(0.1,0.5))+geom_point(aes(x=lon, y=lat, size=M1),alpha=.5,data=df)
  

#############################################GAM#########################################
#########################################################################################

df2<-df[, c(1,4,5,3,2,5)]
df2<-na.omit(df2)


prov<-readShapePoly("Province_2016_polygon.shp")
proj4string(prov)<-"+proj=utm +zone=32 +ellps=WGS84 +units=m +no_defs"
BG<-subset(prov, NOME == "BERGAMO")
BG<-spTransform(BG, CRS("+proj=longlat +ellps=WGS84"))


library(mgvc)










  
  
  
 
 