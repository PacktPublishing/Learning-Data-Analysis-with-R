#Volume 3
#Section 5
#Video 5

#Author: Dr. Fabio Veronesi

library(gstat)
library(sp)
library(moments)
library(DescTools)
library(raster)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Import the dataset we created in Video 2
SO2.Data <- read.csv("SO2_Data.csv")

#Transform into Spatial Object
coordinates(SO2.Data) = ~Lon+Lat

#Load the country boundary polygons from Natural Earth
US.Border <- shapefile("USA_Border.shp")

projection(SO2.Data)=projection(US.Border)


#Transform into UTM
SO2.UTM <- spTransform(SO2.Data, CRS("+init=epsg:3395"))
US.UTM <- spTransform(US.Border, CRS("+init=epsg:3395"))


#Data Transformation
SO2.UTM$SO2.t <- BoxCox(SO2.UTM$SO2, lambda=0.2)


#Trend Model
TM <- SO2.t~Lat+Lon+I(Lon*Lon)+I(Lat*Lat)+I(Lon*Lat)



#Variogram Cloud
var.cloud <- variogram(TM, SO2.UTM, cloud=T)

plot(var.cloud)


#Omni-Directional Variogram
var.omni <- variogram(TM, SO2.UTM)

plot(var.omni)



#Directional Variogram
var.direc <- variogram(TM, SO2.UTM, 
                       alpha=c(0, 30, 45, 90),
                       width=100000)

plot(var.direc)


#Variogram Map
var.map <- variogram(TM, SO2.UTM, map=T, 
                     cutoff=1500000, width=100000)

plot(var.map)



#Variogram model
model <- vgm(psill=0.3,
             model="Sph",
             range=700000,
             nugget=0.6,
             anis=c(0, 0.7))


plot(var.direc, model)


#Fitting the model
fit <- fit.variogram(var.omni, model)

plot(var.direc, fit)
