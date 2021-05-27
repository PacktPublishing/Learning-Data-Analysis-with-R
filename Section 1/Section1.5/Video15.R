#Volume 1
#Section 1
#Video 5

#Author: Dr. Fabio Veronesi

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Download the data from the FTP site
URL <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/2015/010231-99999-2015.gz"
FileName <- "010231-99999-2015.gz"
download.file(URL, destfile=paste0(getwd(),"/",FileName), method="auto", 
              mode="wb")

data.strings <- readLines(gzfile(FileName, open="rt"))


#Functions
Ext.Latitude <- function(x){
  substr(x, start=29, stop=34)
}

Ext.Longitude <- function(x){
  substr(x, start=35, stop=41)
}

Ext.Temp <- function(x){
  substr(x, start=88, stop=92)
}

LAT <- lapply(data.strings, Ext.Latitude)
LON <- lapply(data.strings, Ext.Longitude)
TEMP <- lapply(data.strings, Ext.Temp)


#Create a data.frame we can use for data analysis
DATA <- data.frame(Latitude=as.numeric(unlist(LAT))/1000,
                   Longitude=as.numeric(unlist(LON))/1000,
                   Temperature=as.numeric(unlist(TEMP))/10)

DATA[DATA$Temperature==999.9,"Temperature"] <- NA

str(DATA)

hist(DATA$Temperature, main="Temperature")
