#Volume 2
#Section 4
#Video 4

#Author: Dr. Fabio Veronesi

library(sp)
library(rgdal)
library(raster)
library(plotrix)


#Setting the working directory
setwd("E:/OneDrive/Packt - Data Analysis/Data")


#Load the country boundary polygons from Natural Earth
NatEarth <- shapefile("Shapefile/ne_110m_admin_0_countries.shp")


#Set the URL with the CSV Files
URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"


#Loading CSV Files
USGS <- read.table(file=URL, 
                   sep=",", 
                   header=TRUE, 
                   na.string="")


#Transformation into a spatial object
coordinates(USGS)=~longitude+latitude

#Assign projection
projection(USGS)=CRS("+init=epsg:4326")


#Faults
faults <- shapefile("GeologicalData/FAULTS.SHP")
projection(faults)=projection(NatEarth)


#Plates
plates <- shapefile("GeologicalData/PLAT_LIN.SHP")
projection(plates)=projection(NatEarth)


#Volcano
volcano <- shapefile("GeologicalData/VOLCANO.SHP")
projection(volcano)=projection(NatEarth)


#Color scale
col.scale <- color.scale(USGS$mag,
                         color.spec="rgb",
                         extremes=c("green","yellow","orange","red"),
                         alpha=0.5)


#Size according to depth
size <- rescale(abs(USGS$depth), newrange=c(0,2))


#Let's put together all we learned so far
plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col=col.scale, cex=size, add=T)



#Now we can add info to the plot
#For example a title
plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col=col.scale, cex=size, add=T)
title("Global Earthquakes",cex.main=3)


#or a legend
plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col=col.scale, cex=size, add=T)
title("Global Earthquakes",cex.main=3)
legend("bottom", legend=c("Plates","Faults","Volcanoes"),
       pch=c("-","-","+"), col=c("tomato4","dark grey","blue"),
       bty="o", bg=c("white"), y.intersp=0.75, cex=0.8,
       title="Legend:") 



#We may also want to add a legend for the colors we used for magnitude
#To do so we first need to extract them from col.scale
col.scale <- color.scale(USGS$mag,
                            color.spec="rgb",
                            extremes=c("green","yellow","orange","red"),
                            alpha=0.5)

col.DF <- data.frame(MAG=USGS$mag, COL=col.scale)

col.DF <- col.DF[with(col.DF, order(col.DF[,1])), ]
#More info about sorting data.frame can be found here:
#http://www.statmethods.net/management/sorting.html
#http://www.dummies.com/how-to/content/how-to-sort-data-frames-in-r.html

col.DF$ID <- 1:nrow(col.DF)

breaks <- seq(1,nrow(col.DF),length.out=5)

col.labels <- round(col.DF[col.DF$ID %in% round(breaks,0), "MAG"],2)
col.legend <- paste(col.DF[col.DF$ID %in% round(breaks,0), "COL"])



plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col=col.scale, cex=size, add=T)
title("Global Earthquakes",cex.main=3)
l <- legend("bottom", legend=c("Plates","Faults","Volcanoes"),
       pch=c("-","-","+"), col=c("tomato4","dark grey","blue"),
       bty="o", bg=c("white"), y.intersp=0.75, cex=0.8,
       title="Legend:") 

l

#The position of the new legend can be calculated based on the position
#of the legend placed automatically by R at the bottom of the page.
l2 <- legendg(l$rect$left+l$rect$w, l$rect$top,
        legend=col.labels,
        fill=col.legend,
        bty="o", bg=c("white"), y.intersp=0.75, title="Magnitude", cex=0.8) 



#Two rectangles with different sizes do not look good.
#We can change that by creating a custom rectangle.

#We first need to hide the border of the two legend with bty="n"
plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col=col.scale, cex=size, add=T)
title("Global Earthquakes",cex.main=3)

#We can use the positions of l and l2 to calculate where to plot it!
rect(xleft=l$rect$left, 
     ybottom=l$rect$top-l2$rect$h, 
     xright=l$rect$left+l$rect$w+l2$rect$w, 
     ytop=l$rect$top, 
     col="white", border="black")

#We need to remember to plot it before the legends, or it will cover them.

legend("bottom", 
       legend=c("Plates","Faults","Volcanoes"),
       pch=c("-","-","+"), col=c("tomato4","dark grey","blue"),
       bty="n", bg=c("white"), 
       y.intersp=0.75, 
       cex=0.8,
       title="Legend:") 

l

#The position of the new legend can be calculated based on the position
#of the legend placed automatically by R at the bottom of the page.
legendg(l$rect$left+l$rect$w, l$rect$top,
        legend=col.labels,
        fill=col.legend,
        bty="n", bg=c("white"), 
        y.intersp=0.75, 
        title="Magnitude", cex=0.8) 




#Save the plot
#When you save the plot the coordinates you used for screen
#will change. Therefore we need to calculate them again.
#You need to do some tests to get it right!!

jpeg(filename="Earthquake_legend.jpg", width=4000, height=2000, 
     units="px", res=300)

plot(NatEarth) 
points(volcano, pch="+", col="blue", cex=0.5)
lines(plates, col="tomato4", lty=3)
lines(faults,col="dark grey", lwd=0.5)
plot(USGS, pch=20, col=col.scale, cex=size, add=T)
title("Global Earthquakes",cex.main=3)

#Note:
#The correct coordinates are -10 and -40
#Show that with bottom they are below the plot, and then work
#starting from coordinates 0,0
l <- legend("bottom", 
       legend=c("Plates","Faults","Volcanoes"),
       pch=c("-","-","+"), col=c("tomato4","dark grey","blue"),
       bty="n", bg=c("white"), 
       y.intersp=0.75, 
       title="Legend:") 

l2 <- legendg(l$rect$left+l$rect$w, l$rect$top,
        legend=col.labels,
        fill=col.legend,
        bty="n", bg=c("white"), 
        y.intersp=0.75, 
        title="Magnitude") 

#We can use the positions of l and l2 to calculate where to plot it!
rect(xleft=l$rect$left, 
     ybottom=l$rect$top-l2$rect$h, 
     xright=l$rect$left+l$rect$w+l2$rect$w, 
     ytop=l$rect$top, 
     col="white", border="black")

#We need to remember to plot it before the legends, or it will cover them.

legend(l$rect$left, l$rect$top, 
       legend=c("Plates","Faults","Volcanoes"),
       pch=c("-","-","+"), col=c("tomato4","dark grey","blue"),
       bty="n", bg=c("white"), 
       y.intersp=0.75, 
       title="Legend:") 


#The position of the new legend can be calculated based on the position
#of the legend placed automatically by R at the bottom of the page.
legendg(l$rect$left+l$rect$w, l$rect$top,
        legend=col.labels,
        fill=col.legend,
        bty="n", bg=c("white"), 
        y.intersp=0.75, 
        title="Magnitude") 

dev.off()
