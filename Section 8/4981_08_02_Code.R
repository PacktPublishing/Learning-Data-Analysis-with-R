#Volume 2
#Section 4
#Video 2

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



#Create a multilyer plot
plot(NatEarth) 
plot(USGS, pch=20, col="red", add=T)
lines(plates, col="tomato4", lty=3)
#A full list of the options for lty is:
#http://www.sthda.com/english/wiki/line-types-in-r-lty

lines(faults,col="dark grey", lwd=0.5)
#lwd controls the line width

points(volcano, pch="+", col="blue", cex=0.5)
#As you can see the blue and grey signs appear on top of the red dots

#Since we are interested in showing the earthquakes' locations
#we cannot let them dissapear below the other layers.
#To make sure they are the top layer we need to plot them last.
plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col="red", add=T)



#Zoom to show a subset of the plot
plot(NatEarth) 

z <- zoom(USGS,new=T)
lines(NatEarth)
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col="red", add=T)


#The object z is of class extent
z


#This can be save the subset, now in TIFF
tiff(filename="Earthquake_zoomed.tif", width=4000, height=2000, 
     units="px", res=300)
plot(z,bty="n",xlab="",ylab="")
lines(NatEarth)
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col="red", add=T)
dev.off()

#As you can see the dimensions are wrong and 
#faults are not really shown clearly.
#In fact, to create the perfect plot there is some trial and error
#involved. We may need to plot it a couple of time to the get
#the dimensions right and the elements showing correctly.
tiff(filename="Earthquake_zoomed.tif", width=3000, height=2000, 
     units="px", res=300)
plot(z,bty="n",xlab="",ylab="")
lines(NatEarth)
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=1)
plot(USGS, pch=20, col="red", add=T)
dev.off()


