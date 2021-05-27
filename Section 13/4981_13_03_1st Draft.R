#Volume 3
#Section 4
#Video 3

#Author: Dr. Fabio Veronesi

library(xts)

#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the Crime dataset
Hammersmith <- read.csv("Crimes_Hammersmith_Robbery_2001_2015.csv")


#The standard format: ts
TS <- ts(Hammersmith$Crimes, 
         start=c(2011, 1), 
         end=c(2015, 12), 
         frequency=12)



#Quantify Monthly Changes
Crimes.Jan <- window(TS, 
                     start = c(2011,1), 
                     end = c(2011,3))


Crimes.Jan <- window(TS, 
                     start = c(2011,1), 
                     freq = TRUE)


Jan.ratio <- mean(Crimes.Jan) / mean(TS)

Jan.ratio



#Package XTS
Hammersmith$DATETIME <- as.POSIXct(Hammersmith$DATETIME, "GMT")

XTS <- xts(Hammersmith$Crimes, order.by=Hammersmith$DATETIME)


#Subset xts objects
XTS['2013-03'] #Selection of a particular month

XTS['2014'] #Selection of a particular year

XTS['2013-05/2013-07'] #Selection by time range

#For more info on subsetting xts objects please take a look at:
#https://cran.r-project.org/web/packages/xts/vignettes/xts.pdf


#Time functions
apply.yearly(XTS,FUN=mean)



plot(XTS,main="Crimes - Hammersmith 2011/2015")
lines(apply.quarterly(XTS,FUN=mean),col="green")
lines(apply.yearly(XTS,FUN=mean),col="pink")

lines(apply.yearly(XTS,FUN=max),col="blue",lty=2)
lines(apply.yearly(XTS,FUN=min),col="blue",lty=2)

