#Volume 3
#Section 1
#Video 3

#Author: Dr. Fabio Veronesi

#Load required packages
library(raster)  
library(rgdal)
library(ggplot2)
library(WDI)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data") 


#Download data
CO2 <- WDI(indicator="EN.ATM.CO2E.KT", country="all",start=1960, end=2016)

str(CO2)

#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")


#The World Bank data do not have a spatial component,
#while the Natural Earth data are polygons but without emission data.
#With some simple code we can solve that!
str(NatEarth$admin)

str(unique(CO2$country))



#We can try to attach the CO2 emission to each country
for(country in NatEarth$admin){
  for(YEAR in 1960:2016){
    Value <- CO2[CO2$country==country&CO2$year==YEAR,"EN.ATM.CO2E.KT"]
    
    if(length(Value)>0){
      NatEarth[NatEarth$admin==country, paste0("CO2_",YEAR)] <- as.numeric(paste(Value))
    } else {
      NatEarth[NatEarth$admin==country, paste0("CO2_",YEAR)] <- NA
    }
  }
}


spplot(NatEarth,"CO2_2011",
       main="CO2 Emissions (kt) - Year:2011",
       sub="Source: World Bank") 


#This code does not work because some countries have different names in the two datasets.
NatEarth$admin[169]

unique(CO2$country)[254]



#Load again the Natural Earth data to reset the modifications we did
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")


#Let's use the iso abbreviation
for(country in NatEarth$iso_a2){
  for(YEAR in 1960:2016){
    Value <- CO2[CO2$iso2c==country&CO2$year==YEAR,"EN.ATM.CO2E.KT"]
    
    if(length(Value)>0){
      NatEarth[NatEarth$iso_a2==country, paste0("CO2_",YEAR)] <- as.numeric(paste(Value))
    } else {
      NatEarth[NatEarth$iso_a2==country, paste0("CO2_",YEAR)] <- NA
    }
  }
}



spplot(NatEarth,"CO2_2011",
       main="CO2 Emissions (kt) - Year:2011",
       sub="Source: World Bank") 


