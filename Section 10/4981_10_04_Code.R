#Volume 3
#Section 1
#Video 4

#Author: Dr. Fabio Veronesi

#Load required packages
library(raster)  
library(rgdal)
library(ggplot2)
library(WDI)
library(plotGoogleMaps)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data") 


#Download data
WDI_Data <- WDI(indicator=c("EN.ATM.CO2E.KT", "EN.POP.DNST", "NY.GDP.MKTP.CD"), 
                country="all",start=1980, end=2010)


#Model our data
India <- WDI_Data[WDI_Data$country=="India",]
plot(India$NY.GDP.MKTP.CD, India$EN.POP.DNST)


qplot(NY.GDP.MKTP.CD, EN.POP.DNST, geom="point", data=India)+
  geom_smooth(method = "lm", formula=y ~ log(x), se = T)



#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")

WDI_Map <- NatEarth[NatEarth$admin!="Antarctica",c("iso_a2", "admin", "continent")]


#Let's use the iso abbreviation
for(IND in c("EN.ATM.CO2E.KT", "EN.POP.DNST", "NY.GDP.MKTP.CD")){
  for(country in WDI_Map$iso_a2){
    for(YEAR in 1960:2016){
      Value <- WDI_Data[WDI_Data$iso2c==country&WDI_Data$year==YEAR,IND]
      
      indicator <- switch(which(IND==c("EN.ATM.CO2E.KT", "EN.POP.DNST", "NY.GDP.MKTP.CD")),
                          A="CO2", B="Population", C="GDP")
    
      if(length(Value)>0){
        WDI_Map[WDI_Map$iso_a2==country, paste0(indicator,"_",YEAR)] <- as.numeric(paste(Value))
      } else {
        WDI_Map[WDI_Map$iso_a2==country, paste0(indicator,"_",YEAR)] <- NA
      }
    }
  }
}



map <- plotGoogleMaps(WDI_Map,
                      zcol="Population_2010",
                      zoom=2,
                      fitBounds=F,
                      filename="WDI_Data.html",
                      layerName="World Bank Data",
                      map="GoogleMap")

