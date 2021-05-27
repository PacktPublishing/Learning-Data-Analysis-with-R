#Volume 3
#Section 5
#Video 6

#Author: Dr. Fabio Veronesi

library(gstat)
library(sp)
library(raster)
library(hydroGOF)
library(DescTools)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Import the dataset we created in Video 2
SO2.Data <- read.csv("SO2_Data.csv")



#Transform into Spatial Object
coordinates(SO2.Data) = ~Lon+Lat

#Load the country boundary polygons from Natural Earth
US.Border <- shapefile("USA_Border.shp")

projection(SO2.Data)=projection(US.Border)


#Transform into UTM
SO2.UTM <- spTransform(SO2.Data, CRS("+init=epsg:3395"))
US.UTM <- spTransform(US.Border, CRS("+init=epsg:3395"))


#Data Transformation
SO2.UTM$SO2.t <- BoxCox(SO2.UTM$SO2, lambda=0.2)


#Trend Model
TM <- SO2.t~Lat+Lon+I(Lon*Lon)+I(Lat*Lat)+I(Lon*Lat)



#Omni-Directional Variogram
var.omni <- variogram(TM, SO2.UTM)

#Variogram model
model <- vgm(psill=0.3,
             model="Sph",
             range=700000,
             nugget=0.6,
             anis=c(0, 0.7))

#Fitting the model
fit <- fit.variogram(var.omni, model)

plot(var.omni, fit)



#Cross-Validation
CV <- krige.cv(TM, SO2.UTM, model=fit, nfold=5)
pred <- BoxCoxInv(CV$var1.pred, lambda=0.2)
obs <- BoxCoxInv(CV$observed, lambda=0.2)

mse(pred, obs)


#Repeat Cross-Validation to obtain robust estimates
MSE <- c()
for(i in 1:100){
  CV <- krige.cv(TM, SO2.UTM, model=fit, nfold=5)
  pred <- BoxCoxInv(CV$var1.pred, lambda=0.2)
  obs <- BoxCoxInv(CV$observed, lambda=0.2)
  
  MSE <- append(MSE, mse(pred, obs))
}

mean(MSE)




#Create the prediction grid
grid <- spsample(US.UTM, cellsize=5000, type="regular")

grid$Lat <- grid@coords[,2]
grid$Lon <- grid@coords[,1]


#Estimate the grid
map <- krige(TM, locations=SO2.UTM, model=fit, newdata=grid)

map$var1.pred <- BoxCoxInv(map$var1.pred, lambda=0.2)
map$var1.var <- BoxCoxInv(map$var1.var, lambda=0.2)

gridded(map) <- T
spplot(map)

