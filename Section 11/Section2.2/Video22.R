#Volume 3
#Section 2
#Video 1

#Author: Dr. Fabio Veronesi

#Load required packages
library(spatstat)
library(raster)
library(rgeos)
library(maptools)

install.packages("phonTools")
library(phonTools)

install.packages("plotrix")
library(plotrix)



#Set the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Scripts/Volume 3/Section2/Data")


#Load the data
#These data are provided under the Open Government Licence: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
#at: https://data.police.uk/data/
London_Crimes <- shapefile("London_Crimes.shp")


#Load the border shapefile for London
Border <- shapefile("London_Border.shp")


plot(London_Crimes, pch="+", main="Burglaries Dec 2015")
lines(Border)



#Mean Center
mean_centerX <- mean(London_Crimes@coords[,1])
mean_centerY <- mean(London_Crimes@coords[,2])

points(mean_centerX,mean_centerY,col="red",pch=16)


#Standard Distance
standard_distance <- sqrt(sum(((London_Crimes@coords[,1]-mean_centerX)^2+
                                 (London_Crimes@coords[,2]-mean_centerY)^2))/(nrow(London_Crimes)))

draw.circle(mean_centerX, mean_centerY, 
            radius=standard_distance, border="red", lwd=2)


#Standard Distance Ellipse
sdellipse(London_Crimes@coords, stdev=1, show=T, 
          add=T, col="blue", lwd=2)



#Transform in UTM
BorderUTM <- spTransform(Border, CRS("+init=epsg:32630")) #UTM30N
CrimesUTM <- spTransform(London_Crimes, CRS("+init=epsg:32630"))



#Transform the border polygon into the ppp window
window <- as.owin(BorderUTM)


#Create a point pattern
Crimes_ppp <- ppp(x=CrimesUTM@coords[,1],
                 y=CrimesUTM@coords[,2],
                 window=window)



#Remove duplicates
CrimesUTM <- remove.duplicates(CrimesUTM)


Crimes_ppp <- ppp(x=CrimesUTM@coords[,1],
                  y=CrimesUTM@coords[,2],
                  window=window)


plot(Crimes_ppp)


#Save the ppp object for later use
save(Crimes_ppp, file="Crimes_ppp.RData")
