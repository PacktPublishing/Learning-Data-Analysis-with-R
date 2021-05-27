#Volume 3
#Section 3
#Video 2

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)
library(rgeos)


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


#Download Geological Data
dir.create(paste(getwd(),"/GeologicalData",sep=""))

#Faults
download.file("http://legacy.jefferson.kctcs.edu/techcenter/gis%20data/World/Zip/FAULTS.zip",destfile="GeologicalData/FAULTS.zip")
unzip("GeologicalData/FAULTS.zip",exdir="GeologicalData")

faults <- shapefile("GeologicalData/FAULTS.SHP")
projection(faults)=projection(NatEarth)


#Plates
download.file("http://legacy.jefferson.kctcs.edu/techcenter/gis%20data/World/Zip/PLAT_LIN.zip",destfile="GeologicalData/plates.zip")
unzip("GeologicalData/plates.zip",exdir="GeologicalData")

plates <- shapefile("GeologicalData/PLAT_LIN.SHP")
projection(plates)=projection(NatEarth)


#Volcano
download.file("http://legacy.jefferson.kctcs.edu/techcenter/gis%20data/World/Zip/VOLCANO.zip",destfile="GeologicalData/VOLCANO.zip")
unzip("GeologicalData/VOLCANO.zip",exdir="GeologicalData")

volcano <- shapefile("GeologicalData/VOLCANO.SHP")
projection(volcano)=projection(NatEarth)


#Project in UTM
volcanoUTM <- spTransform(volcano, CRS("+init=epsg:3395"))
faultsUTM <- spTransform(faults, CRS("+init=epsg:3395"))
EarthquakesUTM <- spTransform(USGS, CRS("+init=epsg:3395"))
platesUTM <- spTransform(plates, CRS("+init=epsg:3395"))



#Exclude border lines in plates
plot(plates)

plates$ID <- 1:nrow(plates)

plates <- plates[!plates$ID %in% c(1,4,47,49,51,50,45,6),]

plot(plates)


platesUTM <- spTransform(plates, CRS("+init=epsg:3395"))




#Create the distance matrix
distance.matrix <- matrix(0,nrow(USGS),7,
                          dimnames=list(c(),c("Lat","Lon","Mag","Depth","DistV","DistF","DistP")))

for(i in 1:nrow(EarthquakesUTM)){
  sub <- EarthquakesUTM[i,]
  dist.v <- gDistance(sub,volcanoUTM)
  dist.f <- gDistance(sub,faultsUTM)
  dist.p <- gDistance(sub,platesUTM)
  distance.matrix[i,] <- matrix(c(sub@coords,sub$mag,
                                  sub$depth,dist.v,dist.f,dist.p),ncol=7)
}


distDF <- as.data.frame(distance.matrix)

#write.csv(distDF, "Distance_DF.csv")
#Do not save a new object so that I can replicate the results obtained before.
