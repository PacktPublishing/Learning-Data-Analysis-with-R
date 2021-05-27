#Volume 2
#Section 3
#Video 1

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the DTM we saved in Volume 1
DTM <- raster("DTM_Data/DTM_combine.tif")

DTM

#A raster object is basically a rectangular matrix 
nrow(DTM)

ncol(DTM)

ncell(DTM)


#We can check the resolution of the cells:
res(DTM)


#We can also perform some basic statistics with dedicated functions
cellStats(DTM, stat='mean')


#or simply by extracting the values from the raster
mean(DTM[], na.rm=T)

#Note: in this case always remember to use na.rm=T
#A raster object is always a rectangular matrix even though the 
#rater we have has a different shape
plot(DTM)

DTM[is.na(DTM)] <- 2000
plot(DTM)


#Re-Load the original dataset to continue the script
DTM <- raster("DTM_Data/DTM_combine.tif")


hist(DTM, maxpixels=ncell(DTM))


#Re-Project raster data
#Warning: this operation takes some time!!
DTM_UTM <- projectRaster(DTM, crs=CRS("+init=epsg:3395"))


#By adding the option filename, this can also be saved in one go
DTM_UTM <- projectRaster(DTM, crs=CRS("+init=epsg:3395"), 
                         filename="DTM_UTM.tif")


#Check the results
projection(DTM)

projection(DTM_UTM)


res(DTM)

res(DTM_UTM)
