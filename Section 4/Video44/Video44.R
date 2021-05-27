#Volume 1
#Section 4
#Video 4

#Author: Dr. Fabio Veronesi

#Load the require packages
library(raster)
library(sp)
library(rgdal)
library(maptools)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"

#Loading CSV Files
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")



#Create a new column in our data.frame with
#date/time information in POSIXct
Data$DateTime <- as.POSIXct(Data$time, format = "%Y-%m-%dT%H:%M:%S")


#This allows us to subset the dataset by date or time

#Extract data collected only on day 8th, any month or year
Earthquake.MidDay <- subset(Data, format(DateTime,'%H') %in% paste(10:13))


#This data.frame can be transformed into a SpatialPointsDataFrame
coordinates(Earthquake.MidDay) = ~longitude+latitude
projection(Earthquake.MidDay) = CRS("+init=epsg:4326")


#Export these data in GeoJSON
writeOGR(Earthquake.MidDay, 
         dsn="Earthquake_MidDay.json",
         layer="Earthquake_MidDay",
         driver="GeoJSON")

#Export in KML
writeOGR(Earthquake.MidDay, 
         dsn="Earthquake_MidDay.kml",
         layer="Earthquake_MidDay",
         driver="KML")
