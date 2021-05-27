#Volume 3
#Section 4
#Video 2

#Author: Dr. Fabio Veronesi

library(xts)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the Crime dataset
Hammersmith <- read.csv("Crimes_Hammersmith_Robbery_2001_2015.csv")

View(Hammersmith)


#The standard format: ts
TS <- ts(Hammersmith$Crimes, 
         start=c(2011, 1), 
         end=c(2015, 12), 
         frequency=12)

print(TS)

plot(TS)


#Descriptive Statistics
mean.ts <- mean(TS)
sd.ts <- sd(TS)

plot(TS)
abline(h=mean.ts, col="red")
abline(h=c(mean.ts+sd.ts, mean.ts-sd.ts), col="blue", lty=3)

#Stationarity
#https://people.duke.edu/~rnau/411diff.htm


#Monthly BoxPlot
boxplot(TS ~ cycle(TS))
abline(h=mean.ts, col="red")
abline(h=c(mean.ts+sd.ts, mean.ts-sd.ts), 
       col="blue", lty=3)



#Package XTS
#Read the columns DATETIME in the right format
Hammersmith$DATETIME <- as.POSIXct(Hammersmith$DATETIME, "GMT")

XTS <- xts(Hammersmith$Crimes, order.by=Hammersmith$DATETIME)


plot(XTS, major.format="%d-%m-%Y")

