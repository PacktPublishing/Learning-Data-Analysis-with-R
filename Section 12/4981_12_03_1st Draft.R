#Volume 3
#Section 3
#Video 3

#Author: Dr. Fabio Veronesi

install.packages("scatterplot3d")
library(scatterplot3d)

library(sp)
library(rgdal)
library(raster)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Import Distance Matrix
Distance_Matrix <- read.csv("Distance_DF.csv")


#Data for Clustering
dataCL <- Distance_Matrix[,6:8]


#Euclidean Distance
point1 <- dataCL[24,]
point2 <- dataCL[45,]

Eucl.Distance <- dist(dataCL[c(24,45),])

sqrt((point1$DistV-point2$DistV)^2+(point1$DistF-point2$DistF)^2+(point1$DistP-point2$DistP)^2)



#KMeans Clustering
CL <- kmeans(dataCL, centers=3)

str(CL)

unique(CL$cluster)


#Scatterplot in 3 dimensions
scatterplot3d(Distance_Matrix$DistV,xlab="Distance to Volcano",
              Distance_Matrix$DistF,ylab="Distance to Fault",
              Distance_Matrix$DistP,zlab="Distance to Plate", 
              color = CL$cluster,
              pch=16,angle=120,scale=2,grid=T,box=T)


