#Volume 2
#Section 1
#Video 4

#Author: Dr. Fabio Veronesi

#Install the required packages if not already available
install.packages("ggplot2")


#Load required packages
library(ggplot2)



#Import data from EPA
URL <- "https://raw.githubusercontent.com/fveronesi/PlottingToolbox/master/Sample_Data/EPA_Data_2014.csv"
EPA <- read.csv(URL)

str(EPA)


plot(EPA[,c(5:9)])

plot(EPA[,c(5:9)], col=EPA$State)



qplot(SO2, NO2, data=EPA, geom="point", 
      xlab="SO2 (ppm)", ylab="NO2 (ppm)", col=State) +
  theme_classic()


EPA_noIOWA <- EPA[EPA$State!="Iowa",]

qplot(SO2, NO2, data=EPA_noIOWA, geom="point", 
      xlab="SO2 (ppm)", ylab="NO2 (ppm)", col=CO) +
  scale_color_gradientn(colours=
                          c("blue","light blue","green","orange","red")) +
  theme_classic()




