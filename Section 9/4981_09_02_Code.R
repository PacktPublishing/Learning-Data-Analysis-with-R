#Volume 2
#Section 5
#Video 2

#Author: Dr. Fabio Veronesi

#Install plotGoogleMaps
install.packages("plotGoogleMaps")

library(plotGoogleMaps)

#Load the remaining packages
library(sp)
library(rgdal)
library(raster)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

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


#To know the number to insert in zcol:
names(USGS)


#Test the plotting function
map <- plotGoogleMaps(USGS,
                      zcol=3,
                      zoom=2,
                      fitBounds=F,
                      filename="USGS_GoogleMaps.html",
                      layerName="Earthquakes")


#Custom Map
map <- plotGoogleMaps(USGS,
                      zcol=3,
                      zoom=2,
                      fitBounds=F,
                      filename="Map_GoogleMaps_small.html",
                      layerName="Earthquakes",
                      map="GoogleMap",
                      mapCanvas="Map",
                      map.width="800px",
                      map.height="600px",
                      control.width="200px",
                      control.height="600px")

#To know more about HTML coding please refer to:
#http://www.w3schools.com/html/default.asp
#http://html.com/


help("plotGoogleMaps")
