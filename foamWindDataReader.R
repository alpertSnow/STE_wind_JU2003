########### FOAM sample sets eader ############
### Read .dat file from OF sample sets      ###
### of the PWIDS locations' wind data       ###
### Output the wind data by directions      ###
### Date: 2017-11-08                        ###
### By: xf                                  ###
###############################################

## header

## settings
f1.name <- '/PWIDS&SuperPWIDS_epsilon_k.dat'
f2.name <- '/PWIDS&SuperPWIDS_U.dat'
f1.skip <- 4
f2.skip <- 3
root.dir <- '~/OpenFOAM/thubee-2.1.1/run/STE_wind_JU2003'

## get the dir names
setwd(root.dir)
dirs <- dir(pattern = 'RKE')
wind.degrees <- substr(dirs, 1,3)
dates <- substr(dirs, nchar(dirs)-4+1, nchar(dirs))

## get the latestTime.dir names in sets dir
n.case <- length(dirs)
setwd(paste0(dirs[1], '/sets'))
latestTime.dir <- vector(length = n.case)
for(i in 1:n.case){
        setwd(paste0('../../', dirs[i], '/sets'))
        latestTime.dir[i] <- max(dir())
}
setwd(root.dir)

## read sample sets files
f1.names <- paste0(dirs, '/sets/', latestTime.dir, f1.name)
f2.names <- paste0(dirs, '/sets/', latestTime.dir, f2.name)
f1s <- lapply(f1.names, read.table,  skip = f1.skip, header = FALSE)
f2s <- lapply(f2.names, read.table,  skip = f2.skip, header = FALSE)

## post process


setwd("~/R/projects/STE_wind_JU2003")