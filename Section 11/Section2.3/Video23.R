#Volume 3
#Section 2
#Video 3

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


#Calculate Intensity per square meter
intensity(Crimes_ppp)


#Calculate Intensity per square kilometer
Crimes_rescaled <- rescale(Crimes_ppp, 1000, "km")
intensity(Crimes_rescaled)


#Quadrat count
QC <- quadratcount(Crimes_ppp, nx = 8, ny = 6)

plot(Crimes_ppp,pch="+",cex=0.5,main="Burglaries Dec. 2015")
plot(QC,add=T,col="blue")

plot(intensity(QC, image=T),main="Burglaries Dec. 2015")

help(intensity)

#Tessellation
H <- hextess(Crimes_ppp$window, 500)
QC_T <- quadratcount(Crimes_ppp, tess=H)

plot(intensity(QC_T, image=T),main="Burglaries Dec. 2015")




#Kernel Density
Density <- density.ppp(Crimes_ppp)

plot(Density)


#Various ways to calculate the size of the moving window
bw.diggle(Crimes_ppp)
bw.ppl(Crimes_ppp)
bw.scott(Crimes_ppp)

help(density.ppp)
#Optimized Kernel Density
Total_Density <- density.ppp(Crimes_ppp, 
                             sigma = bw.ppl(Crimes_ppp),
                             diggle=T)

plot(Total_Density, main="Kernel Density")



#Adaptive Density
Var_Density <- adaptive.density(Crimes_ppp,
                                f=0.1,
                                nrep=30)

plot(Var_Density, main="Adaptive Density")

