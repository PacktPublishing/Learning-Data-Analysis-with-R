#Volume 3
#Section 2
#Video 4

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



#Test the spatial ditribution of our data
quadrat.test(quadratcount(Crimes_ppp, nx=4, ny=4), 
             alternative="regular",
             method="MonteCarlo")



quadrat.test(quadratcount(Crimes_ppp, nx=4, ny=4), 
             alternative="clustered",
             method="MonteCarlo")



#Ripley's K function
K <- Kest(Crimes_ppp, correction="good")

plot(K)



K <- Kest(Crimes_ppp, correction="good", rmax=2000)

plot(K)




#G Function
G <- Gest(Crimes_ppp, correction="best")

plot(G)



#Finding hotspots
LR <- scanLRTS(Crimes_ppp, r=2*bw.ppl(Crimes_ppp))
pvals <- eval.im(pchisq(LR, df=1, lower.tail=F))


plot(pvals)
points(Crimes_ppp, pch="+", cex=0.3)


plot(pvals<0.01)
plot(Crimes_ppp$window, add=T)


#Finding Coldspots
LR <- scanLRTS(Crimes_ppp, r=2*bw.ppl(Crimes_ppp), alternative="less")
pvals <- eval.im(pchisq(LR, df=1, lower.tail=F))


plot(pvals)
plot(Crimes_ppp$window, add=T)


plot(pvals<0.01)
plot(Crimes_ppp$window, add=T)
