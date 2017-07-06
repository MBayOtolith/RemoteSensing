##example script, converting .nc to raster
##JHMoxley, July 6 2014
##built from here: http://geog.uoregon.edu/GeogR/topics/netcdf-to-raster.html
library(ncdf4)
library(raster)
library(rasterVis)
library(maptools)
library(maps)

rm(list = ls())
##################################################
##MAKING & MANIPULATING NETCDF FILES
##################################################
# create a small netCDF file, save, and read back in using raster and rasterVis
# generate lons and lats
nlon <- 8; nlat <- 4
dlon <- 360.0/nlon; dlat <- 180.0/nlat
lon <- seq(-180.0+(dlon/2),+180.0-(dlon/2),by=dlon)
lat <- seq(-90.0+(dlat/2),+90.0-(dlat/2),by=dlat)

#genny the data
set.seed(13)
tmp <- rnorm(nlon*nlat)
tmat <- array(tmp, dim = c(nlon, nlat))

londim <- ncdim_def("lon", "degrees_east", as.double(lon))
latdim <- ncdim_def("lat", "degrees_north", as.double(lat))

varname="tmp"
units="z-scores"
dlname <- "test variable -- original"
fillvalue <- 1e20
tmp.def <- ncvar_def(varname, units, list(londim, latdim), fillvalue, 
                     dlname, prec = "single")

#CREATE NETCDF FIlE
ncfname <- "test-netCDF-file.nc"
ncout <- nc_create(ncfname, list(tmp.def), force_v4 = TRUE)
# put the array
ncvar_put(ncout, tmp.def, tmat)

# put additional attributes into dimension and data variables
ncatt_put(ncout, "lon", "axis", "X")  
ncatt_put(ncout, "lat", "axis", "Y")

# add global attributes
title <- "small example netCDF file"
ncatt_put(ncout, 0, "title", title)

# close the file, writing data to disk
nc_close(ncout)
##################################################
##################################################
##BUILDING THEM IN RASTER PACKAGE
##################################################
#set working dir
setwd("/Users/jmoxley/Documents/MBA_GWS/GitTank/RemoteSensing/scratch")

#open nc file
#see file netcdf_ex for file creation & manipulation
tmpin <- raster("test-netCDF-file.nc")

#check out attributes
tmpin   #listing the object returns internal raster attributes
print(tmpin)  #printing the object returns characteristics of source netCDF file

# map the data
world.outlines <- map("world", plot=FALSE)
world.outlines.sp <- map2SpatialLines(world.outlines, proj4string = CRS("+proj=longlat"))

mapTheme <- rasterTheme(region = rev(brewer.pal(10, "RdBu")))
cutpts <- c(-2.5, -2.0, -1.5, -1, -0.5, 0, 0.5, 1.0, 1.5, 2.0, 2.5)
plt <- levelplot(tmpin, margin = F, at=cutpts, cuts=11, pretty=TRUE, par.settings = mapTheme,
                 main="test variable -- as raster layer")
plt + layer(sp.lines(world.outlines.sp, col = "black", lwd = 0.5))
