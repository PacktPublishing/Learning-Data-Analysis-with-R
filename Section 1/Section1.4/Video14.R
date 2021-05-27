#Volume 1
#Section 1
#Video 4

#Author: Dr. Fabio Veronesi

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

URL <- "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/2015/010231-99999-2015.gz"
FileName <- "010231-99999-2015.gz"
download.file(URL, destfile=paste0(getwd(),"/",FileName), method="auto", 
              mode="wb")


data.strings <- readLines(gzfile(FileName, open="rt"))

str(data.strings)

data.strings[[1]]

#The format for these data is available at:
#ftp://ftp.ncdc.noaa.gov/pub/data/noaa/ish-format-document.pdf

#Create function to extract temperature data
Ext.Temp <- function(x){
  substr(x, 88, 92)
}

#Create a vector with temperature data 
TEMP <- lapply(data.strings, Ext.Temp)

unlist(TEMP)

temp.data <- as.numeric(paste(unlist(TEMP)))


