#Volume 2
#Section 1
#Video 1

#Author: Dr. Fabio Veronesi

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Install the required packages if not already available
#install.packages("RCurl")
#install.packages("XML")


#Load required packages
library(RCurl)
library(XML)


#Create a new directory where to download these files
DIR <- paste(getwd(),"/NOAAFiles",sep="")
dir.create(DIR)


#Dowload the tar file with the full NOAA dataset for 2015
URL <- "ftp://ftp.ncdc.noaa.gov/pub/data/gsod/2015/gsod_2015.tar"
download.file(URL, destfile=paste0(DIR,"/gsod_2015.tar"),
              method="auto",mode="wb")

untar(paste0(getwd(),"/NOAAFiles/","gsod_2015.tar"), 
      exdir=paste0(getwd(),"/NOAAFiles"))


#Delete the tar file
unlink(paste0(getwd(),"/NOAAFiles/","gsod_2015.tar"))


#Let's create a data.frame out of all these files
list.gz <- list.files(path="NOAAFiles", pattern="gz", full.names=T)


#Now we have to create a function to loop through this list of files and extract only the information
#we need. In this text file ftp://ftp.ncdc.noaa.gov/pub/data/gsod/GSOD_DESC.txt you can find
#the acronyms for the columns we find in the data.
#As you can see there are no coordinates, these are available in this other txt file:
#ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.txt
#For this reason we also need a function to extract the coordinates from this other file and then
#allow us to attach them to the data.frame we want to create. The key are in the first two columns,
#which uniquely identify each station.

coords.fwt <- read.fwf("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.txt",
                       widths=c(6,1,5,45,7,1,8,1,7,18),
                       skip=21,
                       fill=T)

coords <- data.frame(ID=as.numeric(paste(coords.fwt[,1])),
                     WBAN=as.numeric(paste(coords.fwt[,3])),
                     Lat=as.numeric(paste(coords.fwt$V5)),
                     Lon=as.numeric(paste(coords.fwt$V7)),
                     Elev=as.numeric(paste(coords.fwt$V9)))

#1869              040060 99999   0.000    0.000 -999.0
#1870              040070 99999  65.867  -23.600   30.0
#1871              040100 99999  64.800  -23.033    8.0
#1872              040110 99999      NA       NA     NA
#Some stations have NA values, while for others NA are identified with zeroes for Lat and Lon and
#-999.0 for elevation.

coords[!is.na(coords$Lat)&coords$Lat==0&coords$Lon==0, c(3:5)] <- NA


#Let's take a closer look to the data 
data <- read.table(gzfile(list.gz[1],open="rt"),sep="",header=F,skip=1)


#To extract the data we need we can create a custom function...
extract.NOAA <- function(x){
  data <- read.table(gzfile(x,open="rt"),sep="",header=F,skip=1)
  matrix(c(data$V1[1], data$V2[1], mean(data$V4,na.rm=T), 
           mean(data$V6,na.rm=T), mean(data$V8,na.rm=T), 
           mean(data$V14,na.rm=T)), ncol=6)
}

#...and then use lapply.
NOAA.list <- lapply(list.gz, extract.NOAA)


NOAA.data <- as.data.frame(matrix(unlist(NOAA.list), ncol=6, byrow=T))
names(NOAA.data) <- c("ID", "WBAN", "TempF", "DewPoint", "Pressure", "WindSpeed")


NOAA <- merge(coords, NOAA.data, by=c("ID", "WBAN"))

str(NOAA)


NOAA$TempC <- round((NOAA$TempF - 32) * 0.5556,2)
NOAA$WindSpeedMPS <- NOAA$WindSpeed * 0.514


write.csv(NOAA, file="NOAA_2015.csv", row.names=F)
#For more information on the full experiment please visit:
#http://r-video-tutorial.blogspot.ch/2014/12/accessing-cleaning-and-plotting-noaa.html