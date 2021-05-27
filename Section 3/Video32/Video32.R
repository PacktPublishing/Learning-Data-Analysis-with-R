#Volume 1
#Section 3
#Video 2

#Author: Dr. Fabio Veronesi

#Load the required packages
library(raster)

#For this video we also need to install and load the library netcdf4
#install.packages("ncdf4")
library(ncdf4)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data/NetCDF")

#Create a list with all the files in the directory
#as we saw in video 1.3
ListFiles <- list.files(path=".", pattern=".nc", full.names=TRUE)


#Open a raster file in NetCDF
temp_ncdf <- nc_open(ListFiles[1])

#Visualize the name of the variable
names(temp_ncdf$var)

#NetCDF are 4D data, meaning they have an x and y dimensions
#plus a z dimension, which is the variable;
#and also a time dimension.
#This means that the file has multiple layers, one for each time window.
#We can open it as a multi-layer raster with the function brick
Temperature <- brick(ListFiles[1], varname="t2m", layer="time")

str(Temperature)


#Create a time index for the multi-layer object
TIME <- as.POSIXct(substr(Temperature@data@names, start=2, stop=20), 
                   format="%Y.%m.%d.%H.%M.%S")
df <- data.frame(INDEX = 1:length(TIME), TIME=TIME)

#Now we can create a subset of only the first day of the month
subset <- df[format(df$TIME, "%d") == "01",]

sub.temp <- Temperature[[subset$INDEX]]

temp_day1 <- calc(sub.temp, fun=mean)
plot(temp_day1)



#Alternatively, we can extract only data collected at 6am.
subset <- df[format(df$TIME, "%H") == "06",]

sub.temp <- Temperature[[subset$INDEX]]

temp_hour6 <- calc(sub.temp, fun=mean)
plot(temp_hour6)
