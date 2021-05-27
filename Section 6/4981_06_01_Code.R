#Volume 2
#Section 2
#Video 1

#Author: Dr. Fabio Veronesi


library(sp)
library(rgdal)
library(rgeos)
library(raster)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"


#Loading CSV Files
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")

Data <- na.omit(Data)

#Transformation into a spatial object
coordinates(Data)=~longitude+latitude

#Assign projection
projection(Data)=CRS("+init=epsg:4326")


#Bounding Box
bbox(Data)


gEnvelope(Data)

plot(Data)
lines(gEnvelope(Data), col="blue")


#Centroid
gCentroid(Data)

plot(Data)
points(gCentroid(Data), col="red", pch=16, cex=2)


#Subset by attribute
Mag3 <- Data[round(Data$mag)==3,]

points(Mag3, col="blue", cex=3)



