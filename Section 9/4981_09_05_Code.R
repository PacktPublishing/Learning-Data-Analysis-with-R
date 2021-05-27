#Volume 2
#Section 5
#Video 5

#Author: Dr. Fabio Veronesi

#Install LeafletR
if(packageVersion("devtools") < 1.6) {
  install.packages("devtools")
}
devtools::install_github("chgrl/leafletR")

library(leafletR)

library(sp)
library(rgdal)
library(raster)
library(plotrix)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")


#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"


#Loading CSV Files
USGS <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")


#Transformation into a spatial object
coordinates(USGS)=~longitude+latitude

#Assign projection
projection(USGS)=CRS("+init=epsg:4326")




#First of all we need to convert our data into GeoJSON
USGS.json <- toGeoJSON(USGS)


#Then we can create our first map
map <- leaflet(USGS.json, dest=tempdir())
map


#The function styleGrad allows to create color scales for our points
USGS.style <- styleGrad(prop="mag", 
                        breaks=seq(range(USGS$mag)[1], range(USGS$mag)[2], length.out=6),
                        style.val=terrain.colors(5),
                        leg="Magnitude")

map <- leaflet(data=USGS.json,
               style=USGS.style,
               dest=tempdir())

map



#Change the base map
map <- leaflet(data=USGS.json,
               style=USGS.style,
               dest=tempdir(),
               base.map="positron")
map



#Add popups
map <- leaflet(data=USGS.json,
               style=USGS.style,
               dest=tempdir(),
               base.map="positron",
               popup="*")
map



map <- leaflet(data=USGS.json,
               style=USGS.style,
               dest=tempdir(),
               base.map="positron",
               popup=c("time", "depth", "mag"))
map



#Add labels
map <- leaflet(data=USGS.json,
               style=USGS.style,
               dest=tempdir(),
               base.map="positron",
               popup=c("time", "depth", "mag"),
               label="place")
map




#Add seismic risk
SeismicTable <- read.table("SeismicRiskMap/GSHPUB.DAT", 
                           sep="", 
                           header=F,
                           na.strings="NaN")

SeismicRisk <- rasterFromXYZ(data.frame(X=SeismicTable[,1],
                                        Y=SeismicTable[,2],
                                        Z=SeismicTable[,3]))

projection(SeismicRisk)=projection(NatEarth)


#Transform the raster into contour lines
Contour <- rasterToContour(SeismicRisk)



Contour.Leaflet <- toGeoJSON(Contour)

#We can create a color scale with plotrix
colour.scale <- color.scale(1:(length(Contour$level)-1),
                            color.spec="rgb",
                            extremes=c("red","blue"))

map.style <- styleGrad(pro="level",
                       breaks=Contour$level,
                       style.val=colour.scale,
                       leg="Seismic Risk", 
                       lwd=2)


map <- leaflet(data=list(USGS.json,Contour.Leaflet),
               style=list(USGS.style,map.style),
               dest=tempdir(),
               base.map="positron",
               popup=c("time", "depth", "mag"),
               label=c("place", ""))
map
