#Volume 1
#Section 1
#Video 3

#Author: Dr. Fabio Veronesi

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data/NOAAFiles")


#Create a list with all the files in the directory
FileList <- list.files(path=".", pattern=".gz", full.names=FALSE)

help(list.files)


#Open the first file in the list
data <- read.fwf(gzfile(FileList[1],open="rt"),
                 header=F,
                 skip=1,
                 widths=c(6,1,5,2,8,4,4,108))


#Clean it from unwanted columns
data.clean <- data[,c("V1", "V3", "V5", "V7")]


#Change the names of the columns
names(data.clean) <- c("STN", "WBAN", "YEARMODA", "TEMP")



#A complete tutorial on how to download and access NOAA data is available at:
#http://r-video-tutorial.blogspot.ch/2014/12/accessing-cleaning-and-plotting-noaa.html