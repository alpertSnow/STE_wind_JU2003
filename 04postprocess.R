############### STE_wind_JU2003 ###############
### 04postprocess                           ###
### plot some comparison figures            ###
### Date: 2017-11-12                        ###
### By: xf                                  ###
###############################################

## header

## settings

## convert Ux.obs & Uy.obs into wspd.obs and wdir.obs
f.Ux.obs <- 'Ux_obs_PWIDS.csv'
f.Uy.obs <- 'Uy_obs_PWIDS.csv'
Ux.obs <- read.csv(f.Ux.obs, row.names = 1)
Uy.obs <- read.csv(f.Uy.obs, row.names = 1)
wspd.obs <- sqrt(Ux.obs^2 + Uy.obs^2)
wspd.obs.mean <- apply(wspd.obs, 2, mean, na.rm = TRUE)
wspd.obs.sd<- apply(wspd.obs, 2, sd, na.rm = TRUE)
wdir.obs <- atan(Ux.obs / Uy.obs) / pi * 180 + 180
wdir.obs.mean <- apply(wdir.obs, 2, mean, na.rm = TRUE)
wdir.obs.sd<- apply(wdir.obs, 2, sd, na.rm = TRUE)

## merge mcmc samples 
mcmc <- data.frame(wf.sim$BUGSoutput$sims.list)

## plot
# hists of dir 
hist( wdir.obs[,14], 20, col=rgb(0,0,1,1/4), xlim=c(130,220), freq = FALSE)  # first histogram
hist( mcmc$wdir, 20, col=rgb(1,0,0,1/4), xlim=c(130,220), freq = FALSE, add=T)  # second

# hists of speed
hist( wspd.obs[,14], 20, col=rgb(0,0,1,1/4), xlim=c(0, 15), freq = FALSE)  # first histogram
hist( mcmc$wspd, 20, col=rgb(1,0,0,1/4), xlim=c(0, 15), freq = FALSE, add=T)  # second

# posterior prective test
wdir.post.mean <- mean(mcmc$wdir)
wspd.post.mean <- mean(mcmc$wspd)
Ux.post.mean <- Ux.map['178',] * wspd.post.mean / U.ref
Uy.post.mean <- Uy.map['178',] * wspd.post.mean / U.ref
mydata <- data.frame(c(t(Ux.post.mean), Ux.mu), c(t(Uy.post.mean), Uy.mu))
colnames(mydata) <- c('Ux', 'Uy')
mydata$PWIDS <- rep(colnames(Ux.map), 2)
mydata$type <- c(rep('posterior',n.valid.Ux), rep('measured', n.valid.Ux))
xyplot(Ux~Uy|PWIDS, mydata, groups = type, xlim = c(-4,4), ylim = c(-4,4))
