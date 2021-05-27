#Volume 3
#Section 3
#Video 4

#Author: Dr. Fabio Veronesi

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



#Find the optimal number of clusters
#This approach was suggested by:
#http://www.mattpeeples.net/kmeans.html

CL <- kmeans(dataCL, centers=1)

wss <- CL$totss

for (n.cl in 2:15){
  wss[n.cl] <- sum(kmeans(dataCL,
                       centers=n.cl)$withinss)
}
  
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")





#Scaling
#Do we need scaling?
apply(dataCL, 2, sd)


#Find the optimal number of clusters
dataCL <- scale(dataCL)



CL <- kmeans(dataCL, centers=1)

wss <- CL$totss

for (n.cl in 2:15){
  wss[n.cl] <- sum(kmeans(dataCL,
                          centers=n.cl)$withinss)
}

plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")



#KMeans Clustering
CL <- kmeans(dataCL, centers=4)


#Scatterplot in 3 dimensions
scatterplot3d(Distance_Matrix$DistV,xlab="Distance to Volcano",
              Distance_Matrix$DistF,ylab="Distance to Fault",
              Distance_Matrix$DistP,zlab="Distance to Plate", 
              color = CL$cluster,
              pch=16,angle=120,scale=2,grid=T,box=T)