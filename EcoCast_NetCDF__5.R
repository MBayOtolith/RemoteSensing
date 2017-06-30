####### produce official EcoCast netcdf
##to be integrated as part of plot EcoCast function

#######################
wd=getwd()
#######################

library(raster)
library(sp)
library(ncdf4)

### objects for lon variable
lon <- as.array(seq(-149.750622, -99.875, 0.24875622))
lon_range = as.numeric(list(lon[1],lon[length(lon)]))

### objects for lon variable
lat <- as.array(seq(60.000622, 10.125, -0.24875622))
lat_range = as.numeric(list(lat[1],lat[length(lat)]))

z=t(as.matrix(r))

### objects for time variable
tzone="UTC"
t0=unclass(as.POSIXct(paste(preddate,"00:00:00"),format="%Y-%m-%d %H:%M:%S",origin='1970-1-1',units='seconds', tzone))
t0_global=as.POSIXct(paste(preddate,"00:00:00"),format="%Y-%m-%d %H:%M:%S",origin='1970-1-1',units='seconds', tzone)
t=unclass(as.POSIXct(paste(preddate,"12:00:00"),format="%Y-%m-%d %H:%M:%S",origin='1970-1-1',units='seconds',  tzone))
t1=unclass(as.POSIXct(paste(preddate+1,"00:00:00"),format="%Y-%m-%d %H:%M:%S",origin='1970-1-1',units='seconds', tzone))
t1_global=as.POSIXct(paste(preddate+1,"00:00:00"),format="%Y-%m-%d %H:%M:%S",origin='1970-1-1',units='seconds', tzone)
t_bands=t(as.matrix(list(t0,t1)))

##creation time
tm <- as.POSIXlt(Sys.time(), "UTC", "%Y-%m-%dT%H:%M:%S")

timedim <- ncdim_def('time', "",as.double(t))
latdim <- ncdim_def('latitude', '', as.double(lat))
longdim <- ncdim_def('longitude', '', as.double(lon))
nvdim <- ncdim_def("nv", "", 1:2, create_dimvar=FALSE )

varz <- ncvar_def('ecocast',"",list(longdim,latdim,timedim),-9999,prec = "double")
time_bnds_def <-ncvar_def('time_bnds',"",list(nvdim,timedim))

nc_name=paste(wd,"/EcoCast_",paste(weightings,collapse=" "),'_',preddate,version,'.nc',sep='')
outnc=nc_create(nc_name,list(varz,time_bnds_def))

ncvar_put(outnc,varz,z)
ncvar_put(outnc,time_bnds_def,t_bands)

ncatt_put(outnc,0,"title","Relative Bycatch-Target Catch Probability Index (daily), EcoCast Project ")
ncatt_put(outnc,0,"date_created",strftime(tm , "%Y-%m-%dT%H:%M:%S%z"))
ncatt_put(outnc,0,"geospatial_lon_resolution",as.numeric(0.2487562))
ncatt_put(outnc,0,"geospatial_lat_resolution",as.numeric(0.2487562))
ncatt_put(outnc,0,"geospatial_lat_max",as.numeric(60.000622))
ncatt_put(outnc,0,"geospatial_lat_min",as.numeric(10.249378))
ncatt_put(outnc,0,"geospatial_lat_units","degrees_north")
ncatt_put(outnc,0,"geospatial_lon_max",as.numeric(-99.999378))
ncatt_put(outnc,0,"geospatial_lon_min",as.numeric(-149.750622))
ncatt_put(outnc,0,"geospatial_lon_units","degrees_east")
ncatt_put(outnc,0,"Southernmost_Northing",as.numeric(10.249378))
ncatt_put(outnc,0,"Westernmost_Easting",as.numeric(10.249378))
ncatt_put(outnc,0,"Northernmost_Northing",as.numeric(-149.750622))
ncatt_put(outnc,0,"Easternmost_Easting",as.numeric(-99.999378))
ncatt_put(outnc,0,"time_coverage_start",strftime(t0_global , "%Y-%m-%dT%H:%M:%S%z"))
ncatt_put(outnc,0,"time_coverage_end",strftime(t1_global , "%Y-%m-%dT%H:%M:%S%z"))
ncatt_put(outnc,0,"time_coverage_resolution","PD1")
ncatt_put(outnc,0,"source_data","ERDDAP (ncdcOwDly_LonPM180, jplG1SST, jplMURSST41), CMEMS (SEALEVEL_GLO_SLA_MAP_L4_NRT_OBSERVATIONS_008_026), AVISO+ (msla)")
ncatt_put(outnc,0,"comments",paste(variables_eco[1],",",variables_eco[2],",",variables_eco[3],",",variables_eco[4],",",variables_eco[5]))
ncatt_put(outnc,0,paste0(namesrisk[1],'_weighting'),weightings[1])
ncatt_put(outnc,0,paste0(namesrisk[2],'_weighting'),weightings[2])
ncatt_put(outnc,0,paste0(namesrisk[3],'_weighting'),weightings[3])
ncatt_put(outnc,0,paste0(namesrisk[4],'_weighting'),weightings[4])
ncatt_put(outnc,0,paste0(namesrisk[5],'_weighting'),weightings[5])
ncatt_put(outnc,0,"project","EcoCast")
ncatt_put(outnc,0,"contributor_name","San Diego State University, University of Maryland Center for Environmental Science, NOAA Southwest Fisheries Science Center, University of California Santa Cruz, Old Dominion University")
ncatt_put(outnc,0,"contributor_role","Co-PIs")

ncatt_put(outnc,0,"Conventions","CF-1.6, COARDS, ACDD-1.3")
ncatt_put(outnc,0,"creator_name","NOAA NMFS SWFSC ERD")
ncatt_put(outnc,0,"creator_email","heather.welch@noaa.gov ; erd.data@noaa.gov")
ncatt_put(outnc,0,"creator_url","https://coastwatch.pfeg.noaa.gov/erddap")
ncatt_put(outnc,0,"publisher_name","NOAA NMFS SWFSC ERD")
ncatt_put(outnc,0,"publisher_email","erd.data@noaa.gov")
ncatt_put(outnc,0,"publisher_url","https://coastwatch.pfeg.noaa.gov/erddap")
ncatt_put(outnc,0,"nameing_authority","gov.noaa.pfeg.coastwatch")
ncatt_put(outnc,0,"institution","NOAA NMFS SWFSC ERD")
ncatt_put(outnc,0,"cdm_data_type","grid")
ncatt_put(outnc,0,"keywords","Earth Science > Agriculture > Agricultural Aquatic Sciences > Fisheries, Earth Science > Biosphere > Ecosystems > Marine Ecosystems > Pelagic > Oceanic Zone, Earth Science > Human Dimensions > Environmental Impacts > Conservation, Oceans > Ocean Temperature > Sea Surface Temperature,analysed, blended, composite, deviation, error, estimated, field, g1sst, ghrsst,Oceans > Ocean Chemistry > Chlorophyll,altitude, aqua, center, chemistry, chla, chlorophyll, chlorophyll-a, chlorophyll_concentration_in_sea_water,Atmosphere > Atmospheric Winds > Surface Winds, ocean winds, oceans, scalar, sea, sea surface winds, sea winds, speed, surface, wind, wind stress, oceans > Ocean Circulation > Ocean Currents, ssalto, surface, surface_eastward_geostrophic_sea_water_velocity_assuming_sea_level_for_geoid, surface_northward_geostrophic_sea_water_velocity_assuming_sea_level_for_geoid, Oceans > Ocean Topography > Sea Surface Height, Oceans > Bathymetry/Seafloor Topography > Bathymetry")
ncatt_put(outnc,0,"acknowledgment","Draft version only - to be edited.")
ncatt_put(outnc,0,"summary","The Relative Bycatch-Target Catch Probability Index is produced using a data-driven, multi-species predictive habitat modelling framework. First, boosted regression tree models were fit to determine the habitat preferences of the target species, broadbill swordfish (Xiphias gladius), and three bycatch-sensitive species that interact with the California drift gillnet fishery (leatherback sea turtle (Dermochelys coricea), blue shark (Prionace glauca), California sea lion (Zalophus californianus)). Then, individual species weightings were set to reflect the level of bycatch and management concern for each species. Prediction layers for each species were then combined into a single surface by multiplying the layer by the species weighting, summing the layers, and then re-calculating the range of values in the final predictive surface from -1 (low catch & high bycatch probabilities) to 1 (high catch & low bycatch probabilities).")
ncatt_put(outnc,0,"license","Draft version only - to be edited. These data are available for use without restriction.  Please acknowledge the use of these data with the following statement: PUT STATEMENT HERE. and cite the following publication: PUBLICATION IF THERE IS ONE). The data may be used and redistributed for free but are not intended or legal use, since they may contain inaccuracies. Neither the data contributor, ERD, NOAA, nor the United States Government, nor any of their employees or contractors, makes any warranty, express or implied, including warranties of merchantability and fitness for a particular purpose, or assumes any legal liability for the accuracy, completeness, or usefulness, of this information.")
ncatt_put(outnc,0,"id","https://coastwatch.pfeg.noaa.gov/erddap/griddap/???")


### EcoCast dimension attributes
ncatt_put(outnc,"ecocast","ioos_category", "ecology")
ncatt_put(outnc,"ecocast","long_name", "Relative Bycatch-Target Catch Probability Index")
#ncatt_put(outnc,"ecocast","standard_name","ecocast_relative_bycatch_target_catch_likelihood")
ncatt_put(outnc,"ecocast","valid_max", as.double(1))
ncatt_put(outnc,"ecocast","valid_min", as.double(-1))
ncatt_put(outnc,"ecocast","coverage_content_type","modelResult")
ncatt_put(outnc,"ecocast","cell_methods","time: mean (interval: 1.0 day)")
ncatt_put(outnc,"ecocast","units", "1")
ncatt_put(outnc,"ecocast","comment", "The relative likelihood of catching target species vs bycatch species given the current species weightings. The values range from -1 to 1, indicating high likelihoods of catching bycatch species and target species, respectively.")

### time dimension attributes
ncatt_put(outnc,"time","_CoordinateAxisType", "Time")
ncatt_put(outnc,"time","actual_range", as.numeric(t_bands))
ncatt_put(outnc,"time","axis","T")
ncatt_put(outnc,"time","calendar","gregorian")
ncatt_put(outnc,"time","ioos_category", "Time")
ncatt_put(outnc,"time","long_name", "Centered Time")
ncatt_put(outnc,"time","standard_name","time")
#ncatt_put(outnc,"time","bounds",paste0(as.character(t_bands[1]),"; ",as.character(t_bands[2])))
ncatt_put(outnc,"time","bounds","time_bnds")
ncatt_put(outnc,"time","time_origin", "01-JAN-1970 00:00:00")
ncatt_put(outnc,"time","units", "seconds since 1970-01-01T00:00:00Z")
ncatt_put(outnc,"time","coverage_content_type", "coordinate")

### lat dimension attributes
ncatt_put(outnc,"latitude","_CoordinateAxisType", "Lat")
ncatt_put(outnc,"latitude","actual_range", lat_range)
ncatt_put(outnc,"latitude","valid_max", as.double(61.0))
ncatt_put(outnc,"latitude","valid_min", as.double(10.0))
ncatt_put(outnc,"latitude","axis","Y")
ncatt_put(outnc,"latitude","ioos_category", "Location")
ncatt_put(outnc,"latitude","long_name", "Latitude")
ncatt_put(outnc,"latitude","standard_name","latitude")
ncatt_put(outnc,"latitude","units", "degrees_north")
ncatt_put(outnc,"latitude","point_spacing", "even")
ncatt_put(outnc,"latitude","coverage_content_type", "coordinate")
ncatt_put(outnc,"latitude","comment", "Latitude values are the centers of the grid cells")

### long dimension attributes
ncatt_put(outnc,"longitude","_CoordinateAxisType", "Lon")
ncatt_put(outnc,"longitude","actual_range", lon_range)
ncatt_put(outnc,"longitude","valid_max", as.double(-99.0))
ncatt_put(outnc,"longitude","valid_min", as.double(-150.0))
ncatt_put(outnc,"longitude","axis","X")
ncatt_put(outnc,"longitude","ioos_category", "Location")
ncatt_put(outnc,"longitude","long_name", "longitude")
ncatt_put(outnc,"longitude","standard_name","longitude")
ncatt_put(outnc,"longitude","units", "degrees_east")
ncatt_put(outnc,"longitude","point_spacing", "even")
ncatt_put(outnc,"longitude","coverage_content_type", "coordinate")
ncatt_put(outnc,"longitude","comment", "Longitude values are the centers of the grid cells")

nc_close(outnc)

b=nc_open("EcoCast_-0.2 -0.2 -0.05 -0.9 0.9_2017-04-05_V1.nc")

