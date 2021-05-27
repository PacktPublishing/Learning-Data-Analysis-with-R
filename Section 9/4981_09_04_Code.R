#Volume 2
#Section 5
#Video 4

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)
library(plotGoogleMaps)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")



#Global Seismic Risk Map
dir.create(paste(getwd(),"/SeismicRiskMap",sep=""))

#Provided for free by the Helmhotz center in Postdam
#at: http://gmo.gfz-potsdam.de/
download.file("http://gmo.gfz-potsdam.de/pub/download_data/gshap_pub.zip",
              destfile="SeismicRiskMap/gshap_pub.zip")
unzip("SeismicRiskMap/gshap_pub.zip",exdir="SeismicRiskMap")


SeismicTable <- read.table("SeismicRiskMap/GSHPUB.DAT", 
                           sep="", 
                           header=F,
                           na.strings="NaN")

SeismicRisk <- rasterFromXYZ(data.frame(X=SeismicTable[,1],
                                        Y=SeismicTable[,2],
                                        Z=SeismicTable[,3]))

projection(SeismicRisk)=projection(NatEarth)



#Select by attribute
US <- NatEarth[NatEarth$admin=="United States of America",]

#Seismic Risk US
RiskUS <- crop(SeismicRisk, US)


#Finally we can add the raster
raster <- plotGoogleMaps(RiskUS,
                         zoom=2,
                         legend=T,
                         fitBounds=F,
                         filename="Seismic_Risk.html",
                         layerName="Seismic Risk Map", 
                         fillOpacity=0.4,
                         colPalette=terrain.colors(10))

help(terrain.colors)


#Note:
#During my test I noticed that the function plotGoogleMaps does
#not work well with very large rasters.
#For example, if you try to plot the entire SeismicRisk raster
#the map will show nothing. 

