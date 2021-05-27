#Volume 1
#Section 4
#Video 1

#Author: Dr. Fabio Veronesi

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"

#Loading CSV Files
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")



#Create a new column in our data.frame with
#date/time information in POSIXct
Data$DateTime <- as.POSIXct(Data$time, format = "%Y-%m-%dT%H:%M:%S")




#This allows us to subset the dataset by date or time

#Extract data collected only on day 8th, any month or year
Earthquake.MidDay <- subset(Data, format(DateTime,'%H') %in% paste(10:13))

#Export these data in Tables
#Export in standard CSV
write.table(x=Earthquake.MidDay,
            file="Earthquake_MidDay.csv",
            sep=",",
            row.names=FALSE,
            col.names=TRUE)


#Export in TXT
write.table(x=Earthquake.MidDay,
            file="Earthquake_MidDay.txt",
            sep=" ",
            row.names=FALSE,
            col.names=TRUE)
