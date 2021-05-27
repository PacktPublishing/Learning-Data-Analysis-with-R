#Volume 2
#Section 3
#Video 2

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Nasa data from: https://eosweb.larc.nasa.gov/cgi-bin/sse/global.cgi
URL <- "https://eosweb.larc.nasa.gov/sse/global/text/22yr_T10M"

TempNASA <- read.table(file=URL, 
                       sep=" ", 
                       header=FALSE, 
                       skip=14)

str(TempNASA)

#Subset the data.frame to extract only January
January <- TempNASA[, 1:3]
names(January) <- c("Lat", "Lon", "Temp")

str(January)


#This is not a raster, for the time being it's only a data.frame
#We can convert it with the following function:
TempRaster <- rasterFromXYZ(data.frame(X=January$Lon,
                                       Y=January$Lat,
                                       Z=January$Temp))

class(TempRaster)

plot(TempRaster)


#Convert January into a spatial object
coordinates(January) = ~Lon+Lat

#Now the object January is not a data.frame anymore,
#but A SpatialPointsDataFrame.

#To convert a spatial object into raster we can use 
#the following function:
TempRaster2 <- rasterFromXYZ(January)


#We can also convert raster data into matrixes or spatial objects
#Load the DTM we saved in Volume 1
DTM <- raster("DTM_Data/DTM_combine.tif")

#A raster can be also converted to points
DTM_points <- rasterToPoints(DTM, spatial=T)
#if spatial=F the raster is converted into a matrix

class(DTM_points)