#Volume 1
#Section 2
#Video 3

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

#At this point we have a data.frame, we can take a look at its structure
#with the function str(...)
str(Data)

#Extract the magnitude of the events is simple:
Data$mag



#Transformation into a spatial object
coordinates(Data)=~longitude+latitude

#If we run the str function now we will notice some differences
str(Data)

#However, accessing the magnitude info can be done in the same way.
Data$mag


#It is the same object, but it has been replaced with a SpatialPointsDataFrame
plot(Data)


#We can re-import the shapefile we downloaded in video 2.2 to provide
#a context to this map.
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")

plot(NatEarth, add=T)
