### script to start preparing the 2016 data


##########  3. Downloading jplGH1SST
library(RCurl)
setwd("/Volumes/SeaGate/ERD_DOM/ncdf_2016")
#url<-"http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplG1SST.nc?SST[(2012-01-01):1:(2016-01-13T00:00:00Z)][(30):1:(35)][(-121):1:(-116)]"
#filenm<-paste("jplG1SST_","1990_1_01_all",".nc",sep="")
### RUN MISSING DATES
#dates<-c("1986-05-01","2001-06-01")
#dates<-seq(as.Date("2016/01/01"), as.Date("2016/12/31"), by = "week",format="%Y/%mm/%dd")
#dates<-seq(as.Date("2016/10/21"), as.Date("2017/01/01"), by = "week",format="%Y/%mm/%dd")
years=as.character(seq(from=as.Date("2016-07-23"),to=as.Date("2016-08-04"),by="day"))
#years=list(years,c("2016-12-31","2016-08-30","2016-01-26","2016-01-12"))
years=list(c("2016-12-30","2016-08-29","2016-01-25","2016-01-11"))
dates=unlist(years)
i<-1
while (i < length(dates)){
  startdate<-dates[i]
  enddate<-dates[i+1]
  #enddate<-seq.Date(as.Date(startdate),by="week",length.out=2)[2]
  filenm<-paste("larger_jplG1SST_",startdate,".nc",sep="")
  url<-paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplG1SST.nc?SST[(",startdate,"):1:(",startdate,")][(10):1:(60)][(-150):1:(-100)]",sep="")
  ####http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplL4AvhrrOIv1fv2.nc?analysed_sst[(1981-09-01):1:(2015-04-05T00:00:00Z)][(10):1:(60)][(-150):1:(-100)]
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

### D. An acquire function to grab envt data from erddap
acquire_erddap=function(urls,name,final_name){ #name is for the variable name in ERDDAP, final_name is for the final processed layer (e.g. l.blendchla )
  envir = parent.frame()
  presence=URLexists(urls=urls)
  if(URLexists(urls=urls)==TRUE){
    file = paste(tmpdir,"/",name,".nc",sep="")
    print(paste("Beginning download of ",name,". Placing it in a temp directory: ",tmpdir,sep=""))
    f = CFILE(file,mode="wb")
    curlPerform(url=urls,writedata=f@ref,noprogress=FALSE)
    close(f)
    waitfor(3)
  }
}


#### downloading missing SST files
years=as.character(seq(from=as.Date("2016-07-23"),to=as.Date("2016-08-04"),by="day"))

for(get_date in years){

sst=paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplG1SST.nc?SST[(",get_date,"T00:00:00Z):1:(",get_date,"T00:00:00Z)][(10):1:(60)][(-150):1:(-100)]",sep="") ##fix url for final version
name= "jplG1SST"
acquire_erddap(urls=sst,name=name,final_name=name)

}


#############################################  3. jplMURSSt41 monthly mean and anomaly for BREP turtles

### A. Pauses system for a period of time to allow url requests to go through
waitfor <- function(x){
  p1 <- proc.time()
  Sys.sleep(x)
  print(proc.time() - p1) # The cpu usage should be negligible
}

################### jplMURSST41mday  (monthly mean)
library(RCurl)
setwd("~/R/prediction_layers/NCDF/")  ######## change for each magine
years=as.character(seq(from=as.Date("2002-06-01"),to=as.Date("2017-01-01"),by="month")) ## d.n. start till june
dates=unlist(years)
i<-1
counter=0
time=3
while (i < length(dates)){
  startdate<-dates[i]
  enddate<-dates[i+1]
  #enddate<-seq.Date(as.Date(startdate),by="week",length.out=2)[2]
  filenm<-paste("jplMURSST41mday_",startdate,".nc",sep="")
  url<-paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplMURSST41mday.nc?sst[(",startdate,"):1:(",enddate,")][(10):1:(60)][(-179.99):1:(-100)]",sep="") ##check product name!!
  print(startdate)
  f = CFILE(filenm,mode="wb")
  curlPerform(url=url,writedata=f@ref) 
  close(f)
  i<-i+1
  counter <- sum(counter, 1)
  print(counter)
  if (is.na(file.info(filenm)$size && counter<4)) {
    i<-i-1
    waitfor(time)
    time=sum(time,15)
    print(time)
  }
  else if (file.info(filenm)$size < 2000 && counter<=4){
    i<-i-1
    waitfor(time)
    time=sum(time,15)
    print(time)
  }
  else if (counter>4){
    counter=0
    time=3
  }
}


################### jplMURSST41anommday (monthly anomaly)
#library(RCurl)
#setwd("/Volumes/SeaGate/EcoCast_HW/Early attempts at understanding EcoCast/data")  ######## change for each magine
years=as.character(seq(from=as.Date("2002-06-01"),to=as.Date("2017-01-01"),by="month")) ## d.n. start till june
dates=unlist(years)
i<-1
counter=0
time=3
while (i < length(dates)){
  startdate<-dates[i]
  enddate<-dates[i+1]
  #enddate<-seq.Date(as.Date(startdate),by="week",length.out=2)[2]
  filenm<-paste("jplMURSST41anommday_",startdate,".nc",sep="")
  url<-paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/jplMURSST41anommday.nc?sstAnom[(",startdate,"):1:(",enddate,")][(10):1:(60)][(-179.99):1:(-100)]",sep="") ##check product name!!
  print(startdate)
  f = CFILE(filenm,mode="wb")
  curlPerform(url=url,writedata=f@ref) 
  close(f)
  i<-i+1
  counter <- sum(counter, 1)
  print(counter)
  if (is.na(file.info(filenm)$size && counter<4)) {
    i<-i-1
      waitfor(time)
      time=sum(time,15)
      print(time)
    }
  else if (file.info(filenm)$size < 2000 && counter<=4){
    i<-i-1
    waitfor(time)
    time=sum(time,15)
    print(time)
  }
  else if (counter>4){
    counter=0
    time=3
  }
}


########################## filling in the gaps in 2012 and 2015 data

seagate="/Volumes/SeaGate/ERD_DOM/EcoCast_CodeArchive/SpatialPredictions_EnvData/Satellite/";setwd(seagate)
all_grids=as.list(list.files("/Volumes/SeaGate/ERD_DOM/EcoCast_CodeArchive/SpatialPredictions_EnvData/Satellite/2015-12-31"))
fileslist=list.files(pattern = "2012-*")
missing_years=list()
for(year in fileslist){
  seagate_path=paste(seagate,year,sep="")
  seagate_list=as.list(list.files(seagate_path))
  FileList_missing=as.character(setdiff(all_grids,seagate_list))
  new=lapply(FileList_missing,function(x)paste(seagate_path,"/",x,sep=""))
  missing_years=list(missing_years,new)
}

missing_files4=unlist(missing_years)

##2012 chla
missing=grep("*l.blendChl.grd",missing_files4,value=TRUE)
a=strsplit(missing,"/")
years_chla_2012=unlist(lapply(a,function(x)x[[8]]))
tmpdir="/Volumes/SeaGate/ERD_DOM/ncdf"

for(year in years_chla_2012){
  print(year)
  start=as.character(as.Date(year)-1)
  end=as.character(as.Date(start)+2)
  if(file.exists(paste0(tmpdir,"/erdMBchlaa_",year,".nc"))==FALSE){
  chl=paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMBchla8day_LonPM180.nc?chlorophyll[(",start,"T00:00:00Z):1:(",end,"T00:00:00Z)][(0):1:(0)][(10):1:(60)][(-150):1:(-100)]",sep="")
  print(url)
  name= paste0("erdMBchlaa_",year)
  final_name="l.blendChl"
  acquire_erddap(urls=chl,name=name,final_name=final_name)
  waitfor(5)
  }
}

#2012 ywind
missing=grep("*ywind.grd",missing_files4,value=TRUE)
a=strsplit(missing,"/")
years_ywind_2012=unlist(lapply(a,function(x)x[[8]]))

for(year in years_ywind_2012){
  print(year)
  if(file.exists(paste0(tmpdir,"/ywind_",year,".nc"))==FALSE){
    wind=paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/ncdcOwDly_LonPM180.nc?v[(",year,"T00:00:00Z):1:(",year,"T00:00:00Z)][(10):1:(10)][(10):1:(60)][(-150):1:(-100)]",sep="")
    print(url)
    name= paste0("ywind_",year)
    final_name="ywind"
    acquire_erddap(urls=wind,name=name,final_name=final_name)
  }
}


########## 2015
seagate="/Volumes/SeaGate/ERD_DOM/EcoCast_CodeArchive/SpatialPredictions_EnvData/Satellite/";setwd(seagate)
all_grids=as.list(list.files("/Volumes/SeaGate/ERD_DOM/EcoCast_CodeArchive/SpatialPredictions_EnvData/Satellite/2015-12-31"))
fileslist=list.files(pattern = "2015-*")
missing_years=list()
for(year in fileslist){
  seagate_path=paste(seagate,year,sep="")
  seagate_list=as.list(list.files(seagate_path))
  FileList_missing=as.character(setdiff(all_grids,seagate_list))
  new=lapply(FileList_missing,function(x)paste(seagate_path,"/",x,sep=""))
  missing_years=list(missing_years,new)
}

missing_files4=unlist(missing_years)
missing=missing_files4
a=strsplit(missing,"/")
years_chla_2015=unlist(lapply(a,function(x)x[[8]]))

tmpdir="/Volumes/SeaGate/ERD_DOM/ncdf_2015"

for(year in years_chla_2015){
  print(year)
  start=as.character(as.Date(year)-1)
  end=as.character(as.Date(start)+2)
  if(file.exists(paste0(tmpdir,"/erdMBchlaa_",year,".nc"))==FALSE){
    chl=paste("http://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMBchla8day_LonPM180.nc?chlorophyll[(",start,"T00:00:00Z):1:(",end,"T00:00:00Z)][(0):1:(0)][(10):1:(60)][(-150):1:(-100)]",sep="")
    print(url)
    name= paste0("erdMBchlaa_",year)
    final_name="l.blendChl"
    acquire_erddap(urls=chl,name=name,final_name=final_name)
    waitfor(5)
  }
}

