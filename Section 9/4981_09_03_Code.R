#Volume 2
#Section 5
#Video 3

#Author: Dr. Fabio Veronesi

#Load the remaining packages
library(sp)
library(rgdal)
library(raster)
library(plotGoogleMaps)


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


#Faults
faults <- shapefile("GeologicalData/FAULTS.SHP")
projection(faults)=projection(NatEarth)

#Volcano
volcano <- shapefile("GeologicalData/VOLCANO.SHP")
projection(volcano)=projection(NatEarth)


#To add layers we first need to create the map
#adding the option add=T
seismic <- plotGoogleMaps(USGS,
                          zcol=3,
                          zoom=2,
                          fitBounds=F,
                          filename="USGS.html",
                          layerName="Earthquakes",
                          add=T)


Faults <- plotGoogleMaps(faults,
                         col="blue",
                         legend=F,
                         fitBounds=F,
                         layerName="Faults",
                         filename="USGS.html",
                         previousMap=seismic)




#Let's now add volcanoes as well
seismic <- plotGoogleMaps(USGS,
                          zcol=3,
                          zoom=2,
                          fitBounds=F,
                          filename="USGS.html",
                          layerName="Earthquakes",
                          add=T)

Faults <- plotGoogleMaps(faults,
                         col="blue",
                         legend=F,
                         fitBounds=F,
                         layerName="Faults",
                         filename="USGS.html",
                         add=T,
                         previousMap=seismic)

iconURL <- "http://maps.google.com/mapfiles/kml/paddle/red-stars-lv.png"

Volcanoes <- plotGoogleMaps(volcano,
                            col="blue",
                            legend=F,
                            fitBounds=F,
                            layerName="Volcanoes",
                            filename="USGS.html",
                            previousMap=Faults,
                            iconMarker=rep(iconURL, nrow(volcano)))

