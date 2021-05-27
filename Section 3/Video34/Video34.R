#Volume 1
#Section 3
#Video 4

#Author: Dr. Fabio Veronesi

#Load the required packages
library(rgdal)
library(raster)
library(RCurl)

#We first need to download the raster files from the FTP site
#as we did in video 1.2

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Define the URL of the FTP site
FTP <- "ftp://ftp.star.nesdis.noaa.gov/pub/corp/scsb/wguo/data/VHP_4km/geo_TIFF/"

#Create a list with all the files on the FTP site
list <- getURL(FTP, dirlistonly = FALSE) 

#Clean the list
List.Temp <- strsplit(list, split="\r\n")
FileList <- lapply(List.Temp, substr, start=56, stop=92)

#Create a list of rasters from 2015
Data2015 <- unlist(FileList)[grep("P2015", unlist(FileList))]
Data2015VCI <- unlist(Data2015)[grep("VCI", unlist(Data2015))]

#Create a new directory where to download these files
DIR <- paste(getwd(),"/NDVIRaster",sep="")
dir.create(DIR)

#Loop to download the files
for(FileName in unlist(Data2015VCI)){
  URL <- paste0(FTP, FileName)
  download.file(URL, destfile=paste0(DIR,"/",FileName), method="auto", 
                mode="wb")
}


#Create a list with all the files in the directory
#as we saw in video 1.3
ListFiles <- list.files(path="NDVIRaster", pattern=".tif", 
                        full.names=TRUE)


#Create a stack raster
NDVI2015 <- stack(ListFiles)

names(NDVI2015)

#Using the name of the file we can create a temporal variable
ext.time <- substr(names(NDVI2015), start=17, stop=23)
substr(ext.time, start=5, stop=5) <- "-"
TIME <- as.POSIXct(paste0(ext.time,"-",3),
                   format="%Y-%U-%u", tz="GMT")

#If we want we can assign the temporal variables as the name of the
#layers
names(NDVI2015) <- TIME

#Using the TIME object we can subset the Raster Layer by Month
JunNDVI.layers <- NDVI2015[[which(format(TIME,'%m') %in% c("06"))]]

#Now we can calculate monthly mean and standard deviation
#Note: These may take some time!!
JunNDVI.MEAN <- calc(JanNDVI.layers, fun=mean)
JunNDVI.SD <- calc(JanNDVI.layers, fun=sd)

#We can plot both rasters side by side to check them properly
par(mfrow=c(1,2))
plot(JunNDVI.MEAN)
plot(JunNDVI.SD)
