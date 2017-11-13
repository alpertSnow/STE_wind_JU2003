############### STE_wind_JU2003 ###############
### 01params                                ###
### load pre and obs data                   ###
### set Bayesian inference parameters       ###
### Date: 2017-11-11                        ###
### By: xf                                  ###
###############################################

## header
library(MASS)

## settings
U.ref <- 6.13 # reference wind speed in CFD at H_ref = 30 m
f.Ux.pre <- 'Ux_pre.csv'
f.Uy.pre <- 'Uy_pre.csv'
f.Uz.pre <- 'Uz_pre.csv'
f.k.pre <- 'k_pre.csv'
f.Ux.obs <- 'Ux_obs_PWIDS.csv'
f.Uy.obs <- 'Uy_obs_PWIDS.csv'
n.PWIDS <- 15
i.PWIDS.ignore <- 14 # ignore PWIDS15 for validation
i.PWIDS.na <- 9 # drop PWIDS09 (no valid data)

## read pre and obs data
Ux.pre <- read.csv(f.Ux.pre, row.names = 1)
Uy.pre <- read.csv(f.Uy.pre, row.names = 1)
k.pre <- read.csv(f.k.pre, row.names = 1)
Ux.obs <- read.csv(f.Ux.obs, row.names = 1)
Uy.obs <- read.csv(f.Uy.obs, row.names = 1)

## process pre abd obs data -> mu & covMat (array)
# delete the ignored location in obs
Ux.mu <- colMeans(Ux.obs[, -i.PWIDS.ignore])
Uy.mu <- colMeans(Uy.obs[, -i.PWIDS.ignore])
U.mu <- rbind(Ux.mu, Uy.mu)

Ux.obs.list <- lapply(Ux.obs[, -i.PWIDS.ignore], as.vector)
Uy.obs.list <- lapply(Uy.obs[, -i.PWIDS.ignore], as.vector)
U.obs.list <- mapply(cbind, Ux.obs.list, Uy.obs.list, SIMPLIFY = FALSE)
L1 <- lapply(U.obs.list, cov, use = 'complete.obs')
L2 <- lapply(L1, inv)
U.T.obs.array <- array(unlist(L2), dim = c(nrow(L2[[1]]), ncol(L2[[1]]), length(L2))) # array of inverse covarience matrixs

# delete in pre
Ux.map <- Ux.pre[,1:n.PWIDS][,-i.PWIDS.na][,-i.PWIDS.ignore]
Uy.map <- Uy.pre[,1:n.PWIDS][,-i.PWIDS.na][,-i.PWIDS.ignore]
k.map <- k.pre[,1:n.PWIDS][,-i.PWIDS.na][,-i.PWIDS.ignore]

# wind direction info
wdirs <- as.numeric(row.names(Ux.pre))
n.wdir <- length(wdirs)

## priors for wind direction and relative wind speed
n.valid.U <- length(U.mu)
wdir.Cat <- 1:n.wdir
p.wdir <- rep(1,n.wdir)
logWspdUpper <- 2
logWspdLower <- -2