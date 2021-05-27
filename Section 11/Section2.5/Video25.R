#Volume 3
#Section 2
#Video 5

#Author: Dr. Fabio Veronesi

#Load required packages
library(spatstat)
library(raster)
library(rgeos)
library(maptools)


#Set the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Scripts/Volume 3/Section2/Data")

#Load the ppp object we saved
load("Crimes_ppp.RData")


#For explanatory variable we are going to use open data downloaded from the OpenStreetMap
#Link: http://download.geofabrik.de/

#Import Explanatory Data
PoliceStations <- shapefile("Police.shp")

#Project it in UTM
PoliceUTM <- spTransform(PoliceStations, CRS("+init=epsg:32630"))


#Transform into ppp
Police_ppp <- ppp(x=PoliceUTM@coords[,1],
                  y=PoliceUTM@coords[,2],
                  window=Crimes_ppp$window)


#Calculate the distance from each Police Station
Police <- with(Crimes_ppp, distfun(Police_ppp))


#Hypothesis testing
#Here we are testing whether the distance from a police station may explain the pattern.
#Our null hypothesis is that the pattern is better explained with no explanatory variables.
crimeFit0 <- ppm(Crimes_ppp ~ x)
crimeFit1 <- ppm(Crimes_ppp ~ poly(Police,2))


#To test whether our hypothesis makes sense we can use the anova function
anova(crimeFit0, crimeFit1, test="LRT")

#Since the p-value is very low we can reject the null hypothesis. This does not necessarily imply that
#the distance from a Police Station is what drives the spatial distribution of our data.
#The significance test only rejects the null hypothesis, but does not assess the truthfulness of the 
#alternative hypothesis.


#Relative intensity as a function of the explanatory variable
rh2 <- rhohat(crimeFit1, Police)

plot(rh2)
abline(h=1)

#This plot representes the relative density of burglaries against the distance from police stations.
#The line p=1 is where the model explain the local density.
#In this case the model seems to explain the local pattern relatively well.



#Test our model
FitPolice <- fitted(crimeFit1, dataonly=T)

den <- density(Crimes_ppp, 
               weights=1/FitPolice,
               sigma = bw.ppl(Crimes_ppp),
               diggle=T)

Crimes.den <- density(Crimes_ppp, 
                      sigma = bw.ppl(Crimes_ppp),
                      diggle=T)

par(mfrow=c(1,2))
plot(Crimes.den, main="Density Crimes")
plot(den, main="Density Fitted Model")


#Plot the residuals of the analysis
res.fit <- residuals(crimeFit1)

par(mfrow=c(1,1))
plot(res.fit, pch="", main="Residuals Plot")


#We can also compute the residuals for specific regions
quadrat <- quadrats(Crimes_ppp, nx=8, ny=6)

res <- integral(res.fit, quadrat)
plot(quadrat, do.labels=T, labels=signif(res,2))

#As you can see in some regions the model estimate more crimes compared to reality,
#while in others less than reality.
