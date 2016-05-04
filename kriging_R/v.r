#Variogram model calculations
library(sp)
library(gstat)
library(kriging)
library(maps)
library(rgl)

ftox <- function(f){
	words = strsplit(f, "y")
    x1 = words[[1]][1]
    x1 = strsplit(x1, "x")
    as.numeric(x1[[1]][2])
}

ftoy <- function(f){
	words = strsplit(f, "y")
    y1 = words[[1]][2]
    y1 = strsplit(y1, ".d")
    y = as.numeric(y1[[1]][1])
}

dist1 <- function(x, y){
    sqrt((x+25)^2 + (y-25)^2)
}

dist2 <- function(x, y){
    sqrt((x-60)^2 + (y-150)^2)
}

x=c()
y=c()
d1=c()
d2=c()
z=c()
files = c("x0y0.data", "x25y0.data", "x50y0.data", "x75y0.data", "x100y0.data",
		"x12.5y12.5.data", "x37.5y12.5.data", "x62.5y12.5.data", "x87.5y12.5.data",
		"x0y25.data", "x25y25.data", "x50y25.data", "x75y25.data", "x100y25.data",
		"x12.5y37.5.data", "x37.5y37.5.data", "x62.5y37.5.data", "x87.5y37.5.data",
		"x0y50.data", "x25y50.data", "x50y50.data", "x75y50.data", "x100y50.data")
files = c("x12.5y12.5.data", "x37.5y12.5.data", "x62.5y12.5.data", "x87.5y12.5.data",
		"x12.5y37.5.data", "x37.5y37.5.data", "x62.5y37.5.data", "x87.5y37.5.data")
for (f in files)
{
    dir  = paste("~/Documents/cpm/project/data/", f, sep = "")
    data = data.frame(read.csv(dir, sep=',', header=T))
	xf = ftox(f)
	yf = ftoy(f)
    for ( zeta in data$RSSI ){
    	x  = append(x, xf)
   		y  = append(y, yf)
    	d1 = append(d1, dist1(xf, yf))
    	d2 = append(d2, dist2(xf, yf))
   		z  = append(z, zeta)
   	}
}
df = data.frame(x, y, d1, d2, z)
coordinates(df) = ~x+y
#v = variogram(z~1, df, cutoff = 10000, width = 10)
#v.fit = fit.variogram(v, model = vgm(25, "Sph", 20, 14))
#plot(v, v.fit)