#Volume 1
#Section 4
#Video 3

#Author: Dr. Fabio Veronesi

#Load the required packages
library(raster)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data/DTM_Data")

#Create the DTM as we saw in video 3.3
ListFiles <- list.files(path=".", pattern=".tif", full.names=FALSE)
ListRasters <- lapply(ListFiles, raster)

#Write the results into a new raster
#NOTE: This step may also be time-consuming!!
DTM <- do.call("merge", ListRasters)




#First let's create a new GeoTIFF
writeRaster(DTM, filename="DTM_combine.tif", format="GTiff")

#The same code can be used to create other formats.
writeRaster(DTM, filename="DTM_combine.asc", format="ascii")

#To have a list of formats available we can use:
writeFormats()


