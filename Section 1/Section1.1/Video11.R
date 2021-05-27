#Volume 1
#Section 1
#Video 1

#Author: Dr. Fabio Veronesi

#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"


#Load the CSV File
Data <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")

#Help function
help(read.table)

#Examining the data
str(Data)
