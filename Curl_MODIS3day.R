##########  3. Downloading jplGH1SST
########## JHMoxley, Adapted from script provided by Heather Welch, NOAA
library(RCurl)

#### change
setwd("/Users/jmoxley/Documents/MBA_GWS/RemoteSensing/mbay_MODIS")
dates<-c(seq(as.Date("2002/07/02"), as.Date("2017/03/21"), by = "year",format="%Y/%mm/%dd"), as.Date("2017/03/21"))
minLat="35"
maxLat="39"
minLon="235"
maxLon="240"
####


i<-1
while (i < length(dates)){
  startdate<-dates[i]
  enddate<-dates[i+1]
  filenm<-paste("MODIS3day_mbay_",startdate,".nc",sep="")
  url<-paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMWsstd3day.nc?sst[(",startdate,"):1:(",enddate,")][(0.0):1:(0.0)][(",minLat,"):1:(",maxLat,")][(",minLon,"):1:(",maxLon,")]")
  print(startdate)
  f = CFILE(filenm,mode="wb")
  curlPerform(url=url,writedata=f@ref) 
  close(f)
  i<-i+1
  if (is.na(file.info(filenm)$size)) {
    i<-i-1
  }
  else if (file.info(filenm)$size < 2000){
    i<-i-1
  }
}
