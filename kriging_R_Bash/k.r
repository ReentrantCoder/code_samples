# Krige random data for a specified area using a list of polygons
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

x=c()
y=c()
z=c()
zall=c()
files = c("x0y0.data", "x25y0.data", "x50y0.data", "x75y0.data", "x100y0.data",
		#"x12.5y12.5.data", "x37.5y12.5.data", "x62.5y12.5.data", "x87.5y12.5.data",
		"x0y25.data", "x25y25.data", "x50y25.data", "x75y25.data", "x100y25.data",
		#"x12.5y37.5.data", "x37.5y37.5.data", "x62.5y37.5.data", "x87.5y37.5.data",
		"x0y50.data", "x25y50.data", "x50y50.data", "x75y50.data", "x100y50.data")
for (f in files)
{	
	dir = paste("~/Documents/cpm/project/data/", f, sep = "")
	data = data.frame(read.csv(dir, sep=',', header=T))
	xf = ftox(f)
	yf = ftoy(f)
	x  = append(x, xf)
	y  = append(y, yf)
   	z  = append(z, mean(data$RSSI))
   	zall = append(zall, list(data$RSSI))
}
df = data.frame(x, y, z)
coordinates(df) = ~x+y
if (TRUE) {
	bubble(df, "z")
	xnew = append(x, c(25., 75.))
	ynew = append(y, c(25., 25.))
	locnew = data.frame(xnew, ynew)
	names(locnew) = c("x", "y")
	gridded(locnew) = ~x+y
	x = seq(0, 100, by=1)
	y = seq(0, 50, by =1)
	xv = rep(x, 51)
	yv = rep(y, each = 101)
	in_mat = data.frame(xv, yv)
	names(in_mat) = c("x", "y")
	gridded(in_mat) = ~x+y		
	#kriged = krige(z~x+y, df, in_mat)
	#kriged = krige.cv(z~x+y, data = df, vgm(.59, "Sph", 874, .04))
	#image(kriged)
}
if (FALSE){
	x = c(12.5, 37.5, 62.5, 87.5)
	y = c(12.5, 37.5)
	xv = rep(x, 2)
	yv = rep(y, each = 4)
	in_mat = data.frame(xv, yv)
	names(in_mat) = c("x", "y")
	coordinates(in_mat) = ~x+y
}
#m <- vgm(12, "Exp", 20, 6)
m <- vgm(25, "Sph", 20, 15)
# Leave-one-out cross validation:
#w <- krige.cv(z~x+y, locations = df, model = m , nfold=length(df$z))
#w <- krige(z~x+y, df, df) ##TODO: This is building a model of z that is only linear in x and y. Needs to be more complex than that.
w <- krige.cv(z~x+y, df, df, model = m) ## This is the proper way to make sure that the krige interpolation "bends" to fit the points
#bubble(w , "residual", main = "z: Leave-one-out CV residuals")
s = 0
for (i in 1:15) {
	upper = w$var1.pred[i] + sqrt(w$var1.var[i])
	lower = w$var1.pred[i] - sqrt(w$var1.var[i])
	s = s + sum((zall[[i]] < upper)*(zall[[i]] > lower))
}
s/300. #Should be 67%
zmat <- matrix(df$z, 5,3)
x = c(0,25,50,75,100)
y = c(0, 25,50)
persp3d(x=x, y=y, z=zmat, col = "lightblue")