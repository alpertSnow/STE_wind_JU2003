############### STE_wind_JU2003 ###############
### 01params                                ###
### load pre and obs data                   ###
### set Bayesian inference parameters       ###
### Date: 2017-11-11                        ###
### By: xf                                  ###
###############################################

## header

## settings
U.ref <- 6.13 # reference wind speed in CFD at H_ref = 30 m
f.Ux.pre <- 'Ux_pre.csv'
f.Uy.pre <- 'Uy_pre.csv'
f.Uz.pre <- 'Uz_pre.csv'
f.k.pre <- 'k_pre.csv'
f.Ux.obs.mean <- 'Ux_obs_mean_PWIDS.csv'
f.Uy.obs.mean <- 'Uy_obs_mean_PWIDS.csv'
f.Ux.obs.sd <- 'Ux_obs_sd_PWIDS.csv'
f.Uy.obs.sd <- 'Uy_obs_sd_PWIDS.csv'
n.PWIDS <- 15
i.PWIDS.ignore <- 15 # ignore PWIDS15 for validation

## read pre and obs data
Ux.pre <- read.csv(f.Ux.pre, row.names = 1)
Uy.pre <- read.csv(f.Uy.pre, row.names = 1)
Ux.obs.mean <- read.csv(f.Ux.obs.mean, row.names = 1)
Uy.obs.mean <- read.csv(f.Uy.obs.mean, row.names = 1)
Ux.obs.sd <- read.csv(f.Ux.obs.sd, row.names = 1)
Uy.obs.sd <- read.csv(f.Uy.obs.sd, row.names = 1)

## process pre abd obs data
# delete the NA location in obs
i.Ux.is.na.PWIDS <- which(is.na(Ux.obs.mean) & is.na(Ux.obs.sd))
Ux.mu <- Ux.obs.mean[-c(i.Ux.is.na.PWIDS,i.PWIDS.ignore),]
Ux.R <- Ux.obs.sd[-c(i.Ux.is.na.PWIDS,i.PWIDS.ignore),]^2
Ux.tau <- 1/Ux.R

i.Uy.is.na.PWIDS <- which(is.na(Uy.obs.mean) & is.na(Uy.obs.sd))
Uy.mu <- Uy.obs.mean[-c(i.Uy.is.na.PWIDS,i.PWIDS.ignore),]
Uy.R <- Uy.obs.sd[-c(i.Uy.is.na.PWIDS,i.PWIDS.ignore),]^2
Uy.tau <- 1/Uy.R

# delete in pre
Ux.map <- Ux.pre[,1:n.PWIDS][,-c(i.Ux.is.na.PWIDS,i.PWIDS.ignore)]
Uy.map <- Uy.pre[,1:n.PWIDS][,-c(i.Uy.is.na.PWIDS,i.PWIDS.ignore)]

# wind direction info
wdirs <- as.numeric(row.names(Ux.pre))
n.wdir <- length(wdirs)

## priors for wind direction and relative wind speed
n.valid.Ux <- length(Ux.mu)
n.valid.Uy <- length(Uy.mu)
wdir.Cat <- 1:n.wdir
p.wdir <- rep(1,n.wdir)
logWspdUpper <- 2
logWspdLower <- -2