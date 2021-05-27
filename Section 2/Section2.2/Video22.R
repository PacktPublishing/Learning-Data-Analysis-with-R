#Volume 1
#Section 2
#Video 2

#Author: Dr. Fabio Veronesi

#Load the required packages
library(sp)
library(rgdal)
library(raster)
library(RCurl)


setwd("E:/OneDrive/Packt - Data Analysis/Data")

#For ESRI Shapefile we will use country boundaries from NaturalEarth
#http://www.naturalearthdata.com

#The procedure to download this zip files is similar to what we saw in video 1.2
URL <- "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip"
FileName <- "ne_110m_admin_0_countries.zip"

dir.create(paste0(getwd(),"/Shapefile"))

download.file(URL,
              destfile=paste0(getwd(),"/Shapefile/",FileName))

unzip(paste0(getwd(),"/Shapefile/",FileName),
      exdir=paste0(getwd(),"/Shapefile",sep=""))



#There are two ways to load an ESRI Shapefile
#The first is with the function readOGR in rgdal
NatEarthOGR <- readOGR(dsn="Shapefile/ne_110m_admin_0_countries.shp", 
                       layer="ne_110m_admin_0_countries")

class(NatEarthOGR)
names(NatEarthOGR)
nrow(NatEarthOGR)


#The second is the simplest method, and can be done with the function
#shapefile in the package raster.
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")

class(NatEarth)
names(NatEarth)
nrow(NatEarth)



#Import GeoJSON
#For this example we will use the open data provided by the City of Edinburgh
#available at the following address:
#http://edinburghopendata.info/

#In particular, we will import a dataset of litter reports, which is distributed in GeoJSON
URL <- "http://data.edinburghopendata.info/dataset/53e1cad1-0884-444c-94f1-615bca60a033/resource/3fe94d38-5761-426d-804f-042466b20111/download/litter201501.geojson"
GeoJSON_Edimburgh <- readOGR(getURL(URL), "OGRGeoJSON")

class(GeoJSON_Edimburgh)
names(GeoJSON_Edimburgh)
nrow(GeoJSON_Edimburgh)

