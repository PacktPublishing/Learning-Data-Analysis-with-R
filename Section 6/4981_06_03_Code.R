#Volume 2
#Section 2
#Video 3

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


#Create a directory to download faults lines
dir.create(paste(getwd(),"/GeologicalData",sep=""))

#Faults
download.file("http://legacy.jefferson.kctcs.edu/techcenter/gis%20data/World/Zip/FAULTS.zip",destfile="GeologicalData/FAULTS.zip")
unzip("GeologicalData/FAULTS.zip",exdir="GeologicalData")

faults <- shapefile("GeologicalData/FAULTS.SHP")

projection(faults)=projection(NatEarth)


#Test if the geometries have at least one point in common 
#or no points in common
gIntersects(faults, Japan)


#Test whether geometries share some but not all interior points
gCrosses(faults, Japan)


#Test whether one geometry is completely contained into another
gContains(faults, Japan)


#Extract the faults that are within Japan
inter <- gIntersection(faults, Japan)

plot(inter, col="blue")
lines(Japan)


#Extract the faults that are outside Japan
out <- gDifference(faults, Japan)

plot(out)
lines(Japan, col="red")
