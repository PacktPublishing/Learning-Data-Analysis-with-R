#Volume 1
#Section 3
#Video 1

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

#The list of files from the FTP site is this time a bit more complex to handle.
#We first need to divide by \r\n like the last time
List.Temp <- strsplit(list, split="\r\n")

#This time though this does not create a list of files, 
#but more characters are included.
#Luckily, the file names are always in the same position of the string.
FileList <- lapply(List.Temp, substr, start=56, stop=92)

#Now we have the list of all the files on the FTP site, from 1981.
#We are only interested in files from 2016, so we can use the function grep
#to identify only the string with a certain word in them.
grep("P2016", unlist(FileList))

#Now we can subset the list and obtain only the names of the files from 2016.
Data2016 <- unlist(FileList)[grep("P2016", unlist(FileList))]
Data2016VCI <- unlist(Data2016)[grep("VCI", unlist(Data2016))]

#Create a new directory where to download these files
DIR <- paste(getwd(),"/NDVIRaster",sep="")
dir.create(DIR)

#Loop to download the files
for(FileName in unlist(Data2016VCI)){
  URL <- paste0(FTP, FileName)
  download.file(URL, destfile=paste0(DIR,"/",FileName), method="auto", 
                mode="wb")
}


#Create a list with all the files in the directory
#as we saw in video 1.3
ListFiles <- list.files(path="NDVIRaster", pattern=".tif", full.names=TRUE)


#Open a raster file with rgdal
ndvi.rgdal <- readGDAL(ListFiles[1])

class(ndvi.rgdal)
object.size(ndvi.rgdal)


#Open a raster file with raster
ndvi.raster <- raster(ListFiles[1])

class(ndvi.raster)
object.size(ndvi.raster)
