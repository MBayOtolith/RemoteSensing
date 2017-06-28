##########  3. Downloading jplGH1SST
########## Provided from Heather Welch, NOAA
library(RCurl)

#### change
setwd("~/Desktop/junk")
dates<-seq(as.Date("2016/01/01"), as.Date("2016/02/01"), by = "week",format="%Y/%mm/%dd")
minLat="35"
maxLat="37"
minLon="-122"
maxLon="-120"
####


i<-1
while (i < length(dates)){
  startdate<-dates[i]
  enddate<-dates[i+1]
  filenm<-paste("jplG1SST_",startdate,".nc",sep="")
  url<-paste0("http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplG1SST.nc?SST[(",startdate,"):1:(",enddate,")][(",minLat,"):1:(",maxLat,")][(",minLon,"):1:(",maxLon,")]")
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
