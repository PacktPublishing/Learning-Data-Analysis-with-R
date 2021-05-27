#Volume 2
#Section 1
#Video 2

#Author: Dr. Fabio Veronesi


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Install the required packages if not already available
install.packages("gridExtra")
install.packages("moments")


#Load required packages
library(gridExtra)
library(moments)


#Import the NOAA data
NOAA <- read.csv("NOAA_2015.csv")


data_summary <- data.frame(Temperature = NOAA$TempC, 
                           DewPoint = NOAA$DewPoint,
                           Pressure = NOAA$Pressure,
                           WindSpeed = NOAA$WindSpeed)
						   

#Measure Central Tendency
mean(data_summary[,"Temperature"], na.rm=T)
median(data_summary[,"Temperature"], na.rm=T)


#Measure Spread
var(data_summary[,"Temperature"], na.rm=T)
sd(data_summary[,"Temperature"], na.rm=T)
IQR(data_summary[,"Temperature"], na.rm=T)

quantile(data_summary[,"Temperature"], 0.25, na.rm=T)
quantile(data_summary[,"Temperature"], 0.75, na.rm=T)


#Other important information
skewness(data_summary[,"Temperature"], na.rm=T)
kurtosis(data_summary[,"Temperature"], na.rm=T)


Dmean <- c()
Dmedian <- c()
DStDev <- c()
Dvar <- c()
count <- c()
q25 <- c()
q75 <- c()
dIQR <- c()
skew <- c()
kurto <- c()
Dmin <- c()
Dmax <- c()

for(i in 1:ncol(data_summary)){
  Dmean[i] <- mean(data_summary[,i], na.rm=T)
  Dmedian[i] <- median(data_summary[,i], na.rm=T)
  DStDev[i] <- sd(data_summary[,i], na.rm=T)
  Dvar[i] <- var(data_summary[,i], na.rm=T)
  count[i] <- nrow(data_summary)
  q25[i] <- as.numeric(quantile(data_summary[,i], 0.25, na.rm=T))
  q75[i] <- as.numeric(quantile(data_summary[,i], 0.75, na.rm=T))
  dIQR[i] <- IQR(data_summary[,i], na.rm=T)
  skew[i] <- skewness(data_summary[,i], na.rm=T)
  kurto[i] <- kurtosis(data_summary[,i], na.rm=T)
  Dmin[i] <- min(data_summary[,i], na.rm=T)
  Dmax[i] <- max(data_summary[,i], na.rm=T)
}


summaryDF1 <- data.frame(count, round(Dmin,2), round(q25,2), 
                         round(Dmean,2), round(Dmedian,2), round(q75,2), round(Dmax,2))

summaryDF2 <- data.frame(round(DStDev,2), round(Dvar,2), 
                         round(dIQR,2), round(skew,2), round(kurto,2))

names(summaryDF1) <- c("Count", "Minimum", "1st Quartile", "Mean", "Median", "3rd Quartile", "Maximum")

names(summaryDF2) <- c("Standard Deviation", "Variance", "Interquartile Range", "Skewness", "Kurtosis")

row.names(summaryDF1) <- names(data_summary)
row.names(summaryDF2) <- names(data_summary)


grid.arrange(tableGrob(summaryDF1), tableGrob(summaryDF2), nrow=2)


pdf("Statistical_Summary.pdf", height=5, width=8, paper="a4r")
grid.arrange(tableGrob(summaryDF1), tableGrob(summaryDF2), nrow=2)
dev.off()

write.csv(cbind(summaryDF1,summaryDF2), "Summary.csv")