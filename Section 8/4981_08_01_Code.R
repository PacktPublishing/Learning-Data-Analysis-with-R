#Volume 2
#Section 4
#Video 1

#Author: Dr. Fabio Veronesi

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


#Simple plot
plot(USGS)


#Change the symbol
#A list of all symbols for pch can be found here:
#http://www.endmemo.com/program/R/pchsymbols.php
plot(USGS, pch=20)


#We can also provide a custom symbol
#by copying and pasting it from the characters map in windows
plot(USGS, pch="+")


#Change color
plot(USGS, pch=20, col="red")

#A full list of all the color names can be found here:
#http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
plot(USGS, pch=20, col="slateblue4")


#Size of the marker
plot(USGS, pch=20, col="red", cex=2)



#Add borders
plot(USGS, pch=20, col="red", cex=1)
lines(NatEarth)




#Save the results in jpeg
help(jpeg)

jpeg(filename="Earthquake.jpg", width=4000, height=2000, 
     units="px", res=300)

plot(USGS, pch=20, col="red", cex=1)
lines(NatEarth)

dev.off()
