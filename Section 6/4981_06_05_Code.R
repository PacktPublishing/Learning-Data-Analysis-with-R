#Volume 2
#Section 2
#Video 5

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

#Faults
faults <- shapefile("GeologicalData/FAULTS.SHP")
projection(faults)=projection(NatEarth)


#Extract the faults that are within Japan
inter <- gIntersection(faults, Japan)

#Extract the faults that are outside Japan
out <- gDifference(faults, Japan)


#Merge spatial datasets
union <- gUnion(inter, out)

class(union)


#Merge different geometries
#This creates a SpatialCollections object
union <- gUnion(out, Japan)

class(union)





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
projection(Data)=projection(NatEarth)


#Overlay earthquakes and Natural Earth polygons
overlay <- over(Data, NatEarth)

names(overlay)


Data$Country <- overlay$admin

Data[is.na(Data$Country),"Country"] <- "Offshore"


#Extract only data offshore
Offshore <- Data[Data$Country=="Offshore",]


plot(NatEarth)
points(Offshore, col="red")