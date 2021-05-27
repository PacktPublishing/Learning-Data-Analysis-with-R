#Volume 2
#Section 4
#Video 3

#Author: Dr. Fabio Veronesi


#For this video we need to install a new package
install.packages("plotrix")

library(plotrix)


library(sp)
library(rgdal)
library(raster)

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



#Plot with multiple colors
summary(USGS$mag)

plot(USGS[USGS$mag<1,], pch=20, col="green")
plot(USGS[USGS$mag>=1&USGS$mag<2,], pch=20, col="yellowgreen", add=T)
plot(USGS[USGS$mag>=2&USGS$mag<3,], pch=20, col="yellow", add=T)
plot(USGS[USGS$mag>=3&USGS$mag<4,], pch=20, col="orange", add=T)
plot(USGS[USGS$mag>=4&USGS$mag<=max(USGS$mag),], pch=20, col="red", add=T)
lines(NatEarth)

#Notice that only North America is showing
#This is because the plot window is selected based on the first plot call

plot(USGS[USGS$mag<1,], pch=20, col="green", 
     xlim=bbox(USGS)[1,], ylim=bbox(USGS)[2,])
plot(USGS[USGS$mag>=1&USGS$mag<2,], pch=20, col="yellowgreen", add=T)
plot(USGS[USGS$mag>=2&USGS$mag<3,], pch=20, col="yellow", add=T)
plot(USGS[USGS$mag>=3&USGS$mag<4,], pch=20, col="orange", add=T)
plot(USGS[USGS$mag>=4&USGS$mag<5,], pch=20, col="red", add=T)
lines(NatEarth)

help(color.scale)

#An easier way is the one from plotrix
col.scale <- color.scale(USGS$mag,
                         color.spec="rgb",
                         extremes=c("green","yellow","orange","red"),
                         alpha=0.5)

plot(NatEarth)
plot(USGS, pch=20, col=col.scale, add=T)


#The division of magnitude values is done automatically, but we can check it
plot(USGS$mag, rep(10, length(USGS$mag)), col=col.scale, pch=16, xlab="Magnitude", ylab="Color")

