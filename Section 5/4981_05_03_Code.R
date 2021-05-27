#Volume 2
#Section 1
#Video 3

#Author: Dr. Fabio Veronesi


#Install the required packages if not already available
install.packages("ggplot2")


#Load required packages
library(ggplot2)



#Import data from EPA
URL <- "https://raw.githubusercontent.com/fveronesi/PlottingToolbox/master/Sample_Data/EPA_Data_2014.csv"
EPA <- read.csv(URL)

str(EPA)


Mean.T <- round(mean(EPA$Temp, na.rm=T),2)
SD.T <- round(sd(EPA$Temp, na.rm=T),2)


qplot(Temp, data=EPA, geom="histogram", binwidth=2, 
      xlab="Temperature (°C)", ylab="Frequency") +
  theme_classic() +
  annotate("text", x=-15, y=100, 
           label=paste0("Mean: ", Mean.T, "°C\nStDev: ", SD.T,"°C"))

#Additional themes:
#http://docs.ggplot2.org/dev/vignettes/themes.html

qplot(Temp, data=EPA, geom="histogram", binwidth=2, 
      xlab="Temperature (°C)", ylab="Frequency") +
  theme_classic() +
  facet_wrap(~State)


qplot(Temp, data=EPA, geom="density", 
      xlab="Temperature (°C)", ylab="Frequency", col=State)

