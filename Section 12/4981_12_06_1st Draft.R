#Volume 3
#Section 3
#Video 6

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")


#Import Distance Matrix
Distance_Matrix <- read.csv("Distance_DF.csv")

#Data for Clustering
dataCL <- Distance_Matrix[,6:8]




#Plot our results on a map
coordinates(Distance_Matrix) = ~Lat+Lon
projection(Distance_Matrix) = CRS("+init=epsg:3395")

DistWGS <- spTransform(Distance_Matrix, projection(NatEarth))



#KMeans Clustering
KCL <- kmeans(dataCL, centers=3)


plot(NatEarth)
points(DistWGS, col=KCL$cluster, pch=20)




#Hierarchical Clustering - Complete
HCL <- hclust(dist(dataCL), method="complete")

HCL.1 <- cutree(HCL, k=4)


plot(NatEarth)
points(DistWGS, col=HCL.1, pch=20)




#Hierarchical Clustering - Complete
HCL <- hclust(dist(dataCL), method="complete")

HCL.2 <- cutree(HCL, h=HCL$height[160])


plot(NatEarth)
points(DistWGS, col=HCL.2, pch=20)




#Hierarchical Clustering - Average
HCL <- hclust(dist(dataCL), method="average")

HCL.3 <- cutree(HCL, k=4)


plot(NatEarth)
points(DistWGS, col=HCL.3, pch=20)




#Hierarchical Clustering - Average
HCL <- hclust(dist(dataCL), method="average")

HCL.4 <- cutree(HCL, h=HCL$height[160])


plot(NatEarth)
points(DistWGS, col=HCL.4, pch=20)

