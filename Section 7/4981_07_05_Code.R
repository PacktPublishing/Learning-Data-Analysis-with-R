#Volume 2
#Section 3
#Video 4

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

January <- TempNASA[, 1:3]
names(January) <- c("Lat", "Lon", "Temp")

#Convert into a raster
TempRaster <- rasterFromXYZ(data.frame(X=January$Lon,
                                       Y=January$Lat,
                                       Z=January$Temp))


#Raster operations
#Convert Temperature from degrees celsius to fahrenheit
TempF <- (TempRaster*1.8) + 32

plot(TempF)


#Calculate slope and aspect for the DTM we downloaded

#Load the DTM we saved in Volume 1
DTM <- raster("DTM_Data/DTM_combine.tif")

#Slope
slope <- terrain(DTM, opt="slope", unit="radians")

plot(slope)


#Aspect
aspect <- terrain(DTM, opt="aspect", unit="radians")

plot(aspect)


#Calculate Shaded Relief by hand
#http://pro.arcgis.com/en/pro-app/tool-reference/3d-analyst/how-hillshade-works.htm

#Azimuth
azimuth <- raster(DTM)
azimuth[] <- 315*(pi/180)
names(azimuth)<-"azimuth"


#Zenith
zenith <- raster(DTM)
zenith[] <- 45*(pi/180)
names(zenith)<-"zenith"



##Hillshading
staked<-stack(slope,aspect,azimuth,zenith)
hill.shd<-raster(aspect)
Shading<-((cos(getValues(staked$zenith))*cos(getValues(staked$slope)))+
            (sin(getValues(staked$zenith))*sin(getValues(staked$slope))*
               cos(getValues(staked$azimuth)-getValues(staked$aspect))))
Shading[Shading<0]<-0
hill.shd[]<-255*Shading


##Save Hillshaded relief
#Here the file is saved into an ASCII grid
writeRaster(hill.shd,filename="Shaded_Relief.tif",overwrite=T)
