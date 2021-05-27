#Volume 2
#Section 3
#Video 4

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)


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

#Filtering
TempAboveZero <- TempRaster>0

plot(TempAboveZero)


TempRaster[TempRaster<0] <- NA

plot(TempRaster)


#Aggregate
Temp500Km <- aggregate(TempRaster, fact=5, fun='mean')

plot(Temp500Km)

res(Temp500Km)

#Downscale
Temp50Km <- disaggregate(TempRaster, fact=2, method='bilinear')

plot(Temp50Km)

res(Temp50Km)
