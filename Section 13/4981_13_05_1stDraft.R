#Volume 3
#Section 4
#Video 5

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


#Mean Forecast
mean.forecast <- meanf(TS)

plot(mean.forecast)


#Naive Forecast
naive.forecast <- naive(TS)

plot(naive.forecast,type="l")


#Drift Method
drift <- rwf(TS, drift=TRUE)

plot(drift)


#Seasonal Naive
Snaive.forecast <- snaive(TS)

plot(Snaive.forecast,type="l")


#ARIMA Model
arima.forecast <- auto.arima(TS)

pred <- forecast(arima.forecast, h=10)

plot(pred)




#Validation
Training <- window(TS,
                   start=c(2011,1),
                   end=c(2014,12))

Test <- window(TS,
               start=c(2015,1))


#Fit ARIMA
arima.forecast <- auto.arima(Training,stepwise=F)


#Estimate the test set
pred.test <- forecast(arima.forecast, h=12)

plot(pred.test)
lines(Test)

