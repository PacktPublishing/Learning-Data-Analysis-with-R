#Volume 2
#Section 2
#Video 2

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(rgeos)
library(raster)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")


#Select by attribute
Japan <- NatEarth[NatEarth$admin=="Japan",]


#Centroid can be calculated for every geometry, not only points
gCentroid(Japan)

plot(Japan)
points(gCentroid(Japan), col="red", pch=16)


#Same for the bounding box
bbox(Japan)

gEnvelope(Japan)


plot(Japan)
lines(gEnvelope(Japan), col="blue")



#Area
gArea(Japan)


#Re-Project our data to UTM 54N from : http://spatialreference.org/
JapanUTM <- spTransform(Japan, CRS("+init=epsg:32654"))



#Area
#with some errors related to the simplification of the polygon
gArea(JapanUTM) #in square meters

gArea(JapanUTM)*10^-6 #in square kilometres


#Perimeter
gLength(JapanUTM) #im meters
