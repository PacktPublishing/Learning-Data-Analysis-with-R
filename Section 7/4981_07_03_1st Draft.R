#Volume 2
#Section 3
#Video 3

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

#Load Earthquake data
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


#We can overlay these two using the function extract
USGS_Temp <- extract(TempRaster, USGS)


plot(USGS$mag, USGS_Temp, xlab="Magnitude", ylab="Temperature January")
abline(lm(USGS_Temp~USGS$mag))



#Another technique to master is clipping
#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")

#Select by attribute
Japan <- NatEarth[NatEarth$admin=="Japan",]

#Clip the temperature raster according to the Japan polygon
TempJapan <- crop(TempRaster, Japan)

plot(TempJapan)
lines(Japan)