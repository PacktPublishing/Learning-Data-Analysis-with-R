#Volume 3
#Section 5
#Video 2

#Author: Dr. Fabio Veronesi


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Download data from EPA website
download.EPA <- function(year, property = c("ozone","so2","co","no2","pm25.frm","pm25","pm10","wind","temp","pressure","dewpoint","hap","voc","lead"), type=c("hourly","daily","annual")){
  if(property=="ozone"){PROP="44201"}
  if(property=="so2"){PROP="42401"}
  if(property=="co"){PROP="42101"}
  if(property=="no2"){PROP="42602"}
  
  if(property=="pm25.frm"){PROP="88101"}
  if(property=="pm25"){PROP="88502"}
  if(property=="pm10"){PROP="81102"}
  
  if(property=="wind"){PROP="WIND"}
  if(property=="temp"){PROP="TEMP"}
  if(property=="pressure"){PROP="PRESS"}
  if(property=="dewpoint"){PROP="RH_DP"}
  if(property=="hap"){PROP="HAPS"}
  if(property=="voc"){PROP="VOCS"}
  if(property=="lead"){PROP="lead"}
  
  URL <- paste0("http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/",type,"_",PROP,"_",year,".zip")
  download.file(URL,destfile=paste0(type,"_",PROP,"_",year,".zip"))
  unzip(paste0(type,"_",PROP,"_",year,".zip"),exdir=paste0(getwd()))
  read.table(paste0(type,"_",PROP,"_",year,".csv"),sep=",",header=T)
}


SO2 <- download.EPA(year=2011, property="so2", type="daily")

str(SO2)


#Extract only observations in mainland US
unique(SO2$State.Name)

SO2.US <- SO2[!paste(SO2$State.Name) %in% c("Alaska", "Puerto Rico", "Hawaii", "Virgin Islands"),]


#Fix the Date/Time information
SO2.US$Date.Local[1]

SO2.US$DATE <- as.POSIXct(SO2.US$Date.Local, format="%Y-%m-%d")


#Clean the dataset
SO2.US$Observation.Count

SO2.US <- SO2.US[SO2.US$Observation.Count>20 & SO2.US$Arithmetic.Mean>0,]

nrow(SO2.US)

length(unique(SO2.US$Address))



#Compute monthly means for August
AD = unique(SO2.US$Address)[1]

SO2.Data <- data.frame(Lon=numeric(), Lat=numeric(), SO2=numeric())
for(AD in unique(SO2.US$Address)){
  sub <- SO2.US[paste(SO2.US$Address)==AD,]
  
  sub.Aug <- sub[format(sub$DATE, "%m")=="08",]
  
  SO2.Data[which(AD==unique(SO2.US$Address)),] <- data.frame(Lon=sub.Aug$Longitude[1],
                                                             Lat=sub.Aug$Latitude[1],
                                                             SO2=mean(sub.Aug$Arithmetic.Mean))
  
}

SO2.Data <- na.omit(SO2.Data)

nrow(SO2.Data)


write.csv(SO2.Data, "SO2_Data.csv", row.names=F)
