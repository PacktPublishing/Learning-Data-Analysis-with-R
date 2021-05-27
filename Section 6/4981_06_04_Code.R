#Volume 2
#Section 2
#Video 4

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


#Importing faults
faults <- shapefile("GeologicalData/FAULTS.SHP")
projection(faults)=projection(NatEarth)


#Create a buffer around Japan
#Please not that this dataset is not projected, 
#therefore width needs to be in degrees
Japan_buffer <- gBuffer(Japan, width=5)

plot(Japan_buffer)
lines(Japan, col="red")


#Extract the faults that are within Japan
inter <- gIntersection(faults, Japan_buffer)

plot(inter, col="blue")
lines(Japan)




#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"


#Loading CSV Files
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")


#Transformation into a spatial object
coordinates(Data)=~longitude+latitude

#Assign projection
projection(Data)=CRS("+init=epsg:4326")


#Let's extract two points from our Data
Data$place

plot(Data)
lines(NatEarth)
points(Data[Data$place=="",], col="red", pch=16)
points(Data[Data$place=="",], col="blue", pch=16)


#Distance between points
gDistance(Data[Data$place=="7km SW of Atascadero, California",],
          Data[Data$place=="25km WSW of Arequipa, Peru",])


#To have this distance in meters we need to re-project the earthquake data
DataUTM <- spTransform(Data, CRS("+init=epsg:3395"))

gDistance(DataUTM[DataUTM$place=="7km SW of Atascadero, California",],
          DataUTM[DataUTM$place=="25km WSW of Arequipa, Peru",])



#Distance between polygons
Italy <- NatEarth[NatEarth$admin=="Italy",]

gDistance(Italy, Japan)
