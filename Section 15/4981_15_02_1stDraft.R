#Volume 3
#Section 6
#Video 2

#Author: Dr. Fabio Veronesi

#Load Packages
library(MASS)
library(Hmisc)


#Load Data
data(Boston)


#Quick Check
str(Boston)

head(Boston)


#Summary Statistics
apply(Boston, 2, summary)


#Explanatory Analysis
pairs(Boston)


#Correlation Analysis
cor <- rcorr(as.matrix(Boston))

as.data.frame(cor$r)["medv",]
as.data.frame(cor$P)["medv",]

