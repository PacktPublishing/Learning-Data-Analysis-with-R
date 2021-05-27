#Volume 3
#Section 5
#Video 4

#Author: Dr. Fabio Veronesi

library(gstat)
library(sp)
library(moments)
library(DescTools)
library(hydroGOF)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Import the dataset we created in Video 2
SO2.Data <- read.csv("SO2_Data.csv")


#Transform into Spatial Object
coordinates(SO2.Data) = ~Lon+Lat



#Trend Analysis
LM <- lm(SO2~Lon+Lat, SO2.Data)

mse(predict(LM), SO2.Data$SO2)



LM <- lm(SO2~Lat+Lon+I(Lon*Lon)+I(Lat*Lat)+I(Lon*Lat), SO2.Data)

mse(predict(LM), SO2.Data$SO2)



#Mapping the trend surface
TR <- krige.cv(SO2~Lat+Lon+I(Lon*Lon)+I(Lat*Lat)+I(Lon*Lat), SO2.Data, nfold=5)

mse(TR$var1.pred, TR$observed)



#Normality
hist(SO2.Data$SO2, xlab="Residuals", main="Histogram")

skewness(SO2.Data$SO2)



#Log Tranformation
skewness(log(SO2.Data$SO2))


hist(log(SO2.Data$SO2), 
     xlab="Residuals", main="Histogram")


qqnorm(log(SO2.Data$SO2))
abline(a=0, b=1)



#Box-Cox Tranformation
skewness(BoxCox(SO2.Data$SO2, lambda=0.2))


hist(BoxCox(SO2.Data$SO2, lambda=0.2), 
     xlab="Residuals", main="Histogram")


qqnorm(BoxCox(SO2.Data$SO2, lambda=0.2))
abline(a=0, b=1)
