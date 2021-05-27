#Volume 1
#Section 2
#Video 4

#Author: Dr. Fabio Veronesi

#Load the required packages
library(sp)
library(raster)

#For this video we are going to use the data.frame we created 
#in video 1.1

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"


#Loading CSV Files
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")

Data$latitude[1]
Data$longitude[1]

#Transformation into a spatial object
coordinates(Data)=~longitude+latitude

#Assign projection
projection(Data)=CRS("+init=epsg:4326")


#This is a list of common projections
#from: http://spatialreference.org/
#CRS("+init=epsg:3857") -> wgs84/OSM
#CRS("+init=epsg:4326") -> Unprojected WGS84 for Google Maps
#CRS("+init=epsg:3395") -> wgs84/World Mercator 


#Alternatively projections can be assigned using data from
#another spatial object.
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")

projection(Data)=projection(NatEarth)
