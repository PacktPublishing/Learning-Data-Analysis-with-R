#Volume 2
#Section 1
#Video 5

#Author: Dr. Fabio Veronesi


#Import data from EPA
URL <- "https://raw.githubusercontent.com/fveronesi/PlottingToolbox/master/Sample_Data/EPA_Data_2014.csv"
EPA <- read.csv(URL)



#Outliers may be detected in various ways
#For normally distributed data we may rely on mean and standard deviation
#A common practice is to exclude values that lie outside the interval Mean+or-(3*SD)
#For a normal distribution this means including 99.87% of the values and thus excluding 0.13% of extremes.
#Some authors are more conservatives and identify outliers outside intervals of 2.5 or 2 standard deviations.
#Reference:doi:10.1016/j.jesp.2013.03.013

Mean_Temp <- mean(EPA$Temp, na.rm=T)
SD_Temp <- sd(EPA$Temp, na.rm=T)

Outliers.Temp <- EPA[EPA$Temp>Mean_Temp+(3*SD_Temp) | 
                       EPA$Temp<Mean_Temp-(3*SD_Temp), ]


hist(EPA$Temp, main="", xlab="Temperature")
abline(v=Mean_Temp+(3*SD_Temp),col="red")
abline(v=Mean_Temp-(3*SD_Temp),col="red")


#The problem is that most of the times our data are not normally distributed
#Thus we need a better way to detect outliers.
#One way is by using the Median Absolute Deviation

Mean_Temp <- mean(EPA$Temp, na.rm=T)
MAD_Temp <- mad(EPA$Temp, na.rm=T)

Outliers.Temp <- EPA[EPA$Temp>Mean_Temp+(3*MAD_Temp) | 
                       EPA$Temp<Mean_Temp-(3*MAD_Temp), ]


#Alternatively we can use the box-plot, which automatically detect outliers
BP <- boxplot(EPA$Temp)

BP$out

Outliers.Temp <- EPA[EPA$Temp==BP$out, ]


#Clean the data
EPA.cleaned <- EPA[EPA$Temp<Mean_Temp+(3*MAD_Temp) | 
                       EPA$Temp>Mean_Temp-(3*MAD_Temp), ]

EPA.cleaned <- EPA[EPA$Temp!=BP$out, ]
