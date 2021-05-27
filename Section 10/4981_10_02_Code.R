#Volume 3
#Section 1
#Video 2

#Author: Dr. Fabio Veronesi

#Load required packages
library(raster)  
library(rgdal)
library(ggplot2)

#Install the package to download data from the World Bank
install.packages("WDI")
library(WDI)


#Search for the data to download
WDIsearch("CO2 emissions")


#Find the indicator name
WDIsearch("CO2 emissions")[8,]


#Download data
CO2 <- WDI(indicator="EN.ATM.CO2E.KT", country="all",start=1960, end=2016)

str(CO2)



#Plot some data
CO2_sub <- CO2[CO2$country %in% c("Italy", "Germany", "France", "Spain", "United Kingdom"),]

#CO2_sub2 <- CO2[CO2$country==c("Italy", "Germany", "France", "Spain", "United Kingdom"),]


qplot(year, y=EN.ATM.CO2E.KT, data=CO2_sub, geom="line", col=country, ylab="CO2 Emissions (kt)")



