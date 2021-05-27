#Volume 1
#Section 1
#Video 2

#Author: Dr. Fabio Veronesi

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load required packages
library(RCurl)
library(XML)


#Create a list with all the files on the FTP site
list <- getURL("ftp://ftp.ncdc.noaa.gov/pub/data/gsod/2016/", 
               dirlistonly = TRUE) 

#Clean the list 
FileList <- strsplit(list, split="\r\n")


#Create a new directory where to download these files
DIR <- paste(getwd(),"/NOAAFiles",sep="")
dir.create(DIR)



#Loop to download the files
for(FileName in unlist(FileList)){
  URL <- paste0("ftp://ftp.ncdc.noaa.gov/pub/data/gsod/2016/",FileName)
  download.file(URL, destfile=paste0(DIR,"/",FileName), method="auto", 
                mode="wb")
}



#A more elegant way
DownloadFile <- function(x){
  URL <- paste0("ftp://ftp.ncdc.noaa.gov/pub/data/gsod/2016/",x)
  download.file(URL, destfile=paste0(DIR,"/",x), method="auto", mode="wb")
}

lapply(unlist(FileList)[1:5], DownloadFile)



#Dowload a compressed file
URL <- "ftp://ftp.ncdc.noaa.gov/pub/data/gsod/2015/gsod_2015.tar"
download.file(URL, destfile=paste0(DIR,"/gsod_2015.tar"),
              method="auto",mode="wb")

untar(paste0(getwd(),"/NOAAFiles/","gsod_2015.tar"), 
      exdir=paste0(getwd(),"/NOAAFiles"))


help(unzip)



#For more information on the full experiment please visit:
#http://r-video-tutorial.blogspot.ch/2014/12/accessing-cleaning-and-plotting-noaa.html