#Volume 2
#Section 4
#Video 5

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)
library(plotrix)


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


#Color scale
col.scale <- color.scale(USGS$mag,
                         color.spec="rgb",
                         extremes=c("green","yellow","orange","red"),
                         alpha=0.5)


#Create a temporal column
USGS$DateTime <- as.POSIXct(USGS$time, format = "%Y-%m-%dT%H:%M:%S")

#To know the temporal range of our observation we can use the function range,
#which works with numbers as well as temporal data
range(USGS$DateTime)


days <- unique(format(USGS$DateTime, "%D"))


#Create distinct plots for each day
par(mfrow=c(1,2))
#More info about combining plots can be found here:
#http://www.statmethods.net/advgraphs/layout.html

plot(NatEarth)
title(paste("Earthquakes",days[1]))
plot(USGS[format(USGS$DateTime, "%D")==days[1],], 
     pch=20, col=col.scale, add=T)

plot(NatEarth) 
title(paste("Earthquakes",days[2]))
plot(USGS[format(USGS$DateTime, "%D")==days[2],], 
     pch=20, col=col.scale, add=T)


#After we finish with par we need to reset the plot window
par(mfrow=c(1,1))



#Alternatively we can use the temporal component to calculate a temporal distance
temp.dist <- Sys.time()-USGS$DateTime

#Temporal Color scale
Tcol.scale <- color.scale(as.numeric(temp.dist),
                          color.spec="rgb",
                          extremes=c("blue","yellow","red"))

plot(NatEarth)
plot(USGS[format(USGS$DateTime, "%D")==days[2],], 
     pch=20, col=Tcol.scale, size=USGS$mag, add=T)

help(mfrow)
