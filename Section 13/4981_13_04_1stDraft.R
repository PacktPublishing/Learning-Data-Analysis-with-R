#Volume 3
#Section 4
#Video 4

#Author: Dr. Fabio Veronesi

library(xts)
library(forecast)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the Crime dataset
Hammersmith <- read.csv("Crimes_Hammersmith_Robbery_2001_2015.csv")


#The standard format: ts
TS <- ts(Hammersmith$Crimes, 
         start=c(2011, 1), 
         end=c(2015, 12), 
         frequency=12)

plot(TS)

#Linear Trend
l.trend <- lm(TS ~ index(TS))

plot(TS)
abline(l.trend, col="red")



#Decomposition
dec <- decompose(TS)

plot(dec)



STL <- stl(TS,"periodic")

plot(STL)


#Plot only the trend
plot(STL$time.series[,2], main="Trend", ylab="")


#Plot only the seasonal component
plot(STL$time.series[,1], main="Seasonal", ylab="")


#Plot only the random component
plot(STL$time.series[,3], main="Random", ylab="")



#Correlogram
acf(TS)


acf(STL$time.series[,3], main="Random")


#Same function from forecast package
Acf(STL$time.series[,3], main="Random")



#Cross-Correlation
KensingtonChelsea <- read.csv("Crimes_KensingtonChelsea_Robbery_2001_2015.csv")

TS2 <- ts(KensingtonChelsea$Crimes, 
          start=c(2011, 1), 
          end=c(2015, 12), 
          frequency=12)

plot(TS)
lines(TS2, col="red")



CC <- Ccf(TS, TS2, lag.max=24)

print(CC)


Ccf(decompose(TS)$random, 
    decompose(TS2)$random, 
    lag.max=24,na.action=na.omit,main="Random Component")

