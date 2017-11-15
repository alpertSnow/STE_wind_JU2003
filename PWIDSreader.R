############# JU2003 PWIDS reader #############
### Read  PWIDS data of JU2003              ###
### Output mean values of a time range      ###
### Date: 2017-11-09                        ###
### By: xf                                  ###
###############################################

## header
library(zoo)
library(data.table)
library(dplyr)

## settings
root.dir <- 'E:/R/STE_wind_JU2003'
f1.name.head <- 'dpg_pwids'
f1.name.tail <- '-0318000-0321024.dat'
f1.n <- 15
f1.dir <- 'E:/实测数据/JointUrban2003/PWID&Hobo&PNNLmet/DPG_PWIDS/dpg_pwids-1144940441'
f1.skip <- 61
f1.vars <- c('Julian.date', 'time', 'speed', 'direction', 'temp', 'RH', 'QC.flag')
time.start <- as.POSIXct('2003-07-27 01:00:00', tz = 'GMT')
time.end <- as.POSIXct('2003-07-27 01:30:00', tz = 'GMT')

## load data to lists of observations
setwd(f1.dir)
Ux.obs <- list()
Uy.obs <- list()
clock <- progress_estimated(f1.n)
for(i in 1:f1.n){
        f1.name <- paste0(f1.name.head, sprintf('%02d',i), f1.name.tail)
        meta <- fread(f1.name, skip = f1.skip, header = FALSE, col.names = f1.vars)
        QC.flag <- sprintf('%04d', meta$QC.flag)
        times <- as.POSIXct(strptime(paste(meta$Julian.date, meta$time, sep=" "), format="%Y%j %H:%M:%S", tz = 'GMT'))
        meta.ts <- zoo(meta[,-(1:2), with = FALSE], order.by = times)
        IOP.ts <- meta.ts[time(meta.ts) >= time.start & time(meta.ts) <= time.end & substr(QC.flag,1,2) == '00',]
        Ux <- with(IOP.ts, - speed * sinpi(direction / 180))
        Uy <- with(IOP.ts, - speed * cospi(direction / 180))
        Ux.obs[[i]] <- Ux
        Uy.obs[[i]] <- Uy
        clock$tick()$print()
}
names(Ux.obs) <- paste0('PWIDS', sprintf('%02d',1:f1.n))
names(Uy.obs) <- paste0('PWIDS', sprintf('%02d',1:f1.n))
Ux.obs.dt <- do.call("merge.zoo", Ux.obs)
Uy.obs.dt <- do.call("merge.zoo", Uy.obs)

## write
setwd(root.dir)
write.csv(Ux.obs.dt, 'Ux_obs_PWIDS.csv')
write.csv(Uy.obs.dt, 'Uy_obs_PWIDS.csv')