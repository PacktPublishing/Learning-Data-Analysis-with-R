#Volume 3
#Section 3
#Video 5

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


#The two most common types of linkages are Complete and Average
#Hierarchical Clustering - Complete
HCL <- hclust(dist(dataCL), method="complete")

plot(HCL)


#Hierarchical Clustering - Average
HCL <- hclust(dist(dataCL), method="average")

plot(HCL)


#Cut the tree by specifying k
HCL.cut <- cutree(HCL, k=4)

str(HCL.cut)


#Let's plot the results
scatterplot3d(Distance_Matrix$DistV,xlab="Distance to Volcano",
              Distance_Matrix$DistF,ylab="Distance to Fault",
              Distance_Matrix$DistP,zlab="Distance to Plate", 
              color = HCL.cut,
              pch=16,angle=120,scale=2,grid=T,box=T)




#Cut the tree by specifying distance h
plot(HCL)
abline(h=HCL$height[160],col="red")


HCL.cut <- cutree(HCL, h=HCL$height[160])

str(HCL.cut)


#Let's plot the results
scatterplot3d(Distance_Matrix$DistV,xlab="Distance to Volcano",
              Distance_Matrix$DistF,ylab="Distance to Fault",
              Distance_Matrix$DistP,zlab="Distance to Plate", 
              color = HCL.cut,
              pch=16,angle=120,scale=2,grid=T,box=T)
