#Volume 3
#Section 5
#Video 3

#Author: Dr. Fabio Veronesi

library(gstat)
library(sp)
library(hydroGOF)
library(raster)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Import the dataset we created in Video 2
SO2.Data <- read.csv("SO2_Data.csv")


#Data Summary
summary(SO2.Data$SO2)


#Transform into Spatial Object
coordinates(SO2.Data) = ~Lon+Lat


#Cross-Validation - 1 Out
CV <- krige.cv(SO2~1, locations=SO2.Data)


#Compute CV accuracy
plot(CV$var1.pred, CV$observed, 
     xlab="Predicted", ylab="Observed")
abline(lm(CV$observed~CV$var1.pred), col="blue")
abline(a=0, b=1, col="red")

#R Squared
cor(CV$var1.pred, CV$observed)^2
#http://blog.minitab.com/blog/adventures-in-statistics/regression-analysis-how-do-i-interpret-r-squared-and-assess-the-goodness-of-fit

#Mean Squared Error
mse(CV$var1.pred, CV$observed)
#https://en.wikipedia.org/wiki/Mean_squared_error

#Mean Absolute Error
mae(CV$var1.pred, CV$observed)
#https://en.wikipedia.org/wiki/Mean_absolute_error

#Root Mean Squared Error
rmse(CV$var1.pred, CV$observed)
#https://en.wikipedia.org/wiki/Root-mean-square_deviation


#Cross-Validation - n-fold
CV <- krige.cv(SO2~1, locations=SO2.Data, nfold=5)


#Compute CV accuracy
plot(CV$var1.pred, CV$observed, 
     xlab="Predicted", ylab="Observed")
abline(lm(CV$observed~CV$var1.pred), col="blue")
abline(a=0, b=1, col="red")


cor(CV$var1.pred, CV$observed)^2

mse(CV$var1.pred, CV$observed)



#Load the country boundary polygons from Natural Earth
US.Border <- shapefile("USA_Border.shp")

projection(SO2.Data)=projection(US.Border)

plot(US.Border)


#Create the prediction grid
grid <- spsample(US.Border, n=5000, type="regular")

grid <- spsample(US.Border, cellsize=0.5, type="regular")

points(grid, pch="+")



#Estimate the grid
map <- idw(SO2~1, locations=SO2.Data, newdata=grid)

spplot(map, "var1.pred")


gridded(map) <- T
plot(map)


