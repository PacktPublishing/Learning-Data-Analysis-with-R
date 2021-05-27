#Volume 1
#Section 2
#Video 5

#Author: Dr. Fabio Veronesi

#For this video we are going to use the data.frame we created 
#in video 1.1

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")

#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"

#Loading CSV Files
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")

#We can identify the column with time data with names()
names(Data)

#Is this column in the right format?
class(Data$time)

#Let's examine one entry of this vector
Data$time[1]


Date.Class <- as.Date(Data$time[1], format = "%Y-%m-%dT%H:%M:%S")
#The abbreviations used for the option format can be found here:
#http://www.inside-r.org/r-doc/base/strptime

class(Date.Class)


#The powerful POSIYct format
Date.Pos <- as.POSIXct(Data$time[1], format = "%Y-%m-%dT%H:%M:%S")

class(Date.Pos)

#This tranformation can be done for the whole data.frame at once.
#Thus, we can create a new column in our data.frame with
#date/time information in POSIXct
Data$DateTime <- as.POSIXct(Data$time, format = "%Y-%m-%dT%H:%M:%S")

class(Data$DateTime)


#This allows us to subset the dataset by date or time
#Extract data before or equal to the 8th of June at 12:30
subset(Data, DateTime <= as.POSIXct('2016-06-08 12:30'))

#Extract data after the 8th of June at 12:30
subset(Data, DateTime > as.POSIXct('2016-06-08 12:30'))

#Extract data collected only at 11, 12 and 13, any day or month
subset(Data, format(DateTime,'%H') %in% c("11","12","13"))

#Extract data collected only on day 8th, any month or year
subset(Data, format(DateTime,'%d') == "08")

#More examples available at:
#https://stat.ethz.ch/pipermail/r-help/2011-September/289364.html