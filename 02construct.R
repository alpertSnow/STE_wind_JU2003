############### STE_wind_JU2003 ###############
### 02construct                             ###
### construct wind finder BUGS/JAGS model   ###
### Date: 2017-11-11                        ###
### By: xf                                  ###
###############################################

library(R2WinBUGS)
windfinder <- function(){
        # likelihood
        for(i in 1:n.valid.U){
                wspd.x[i] <- Ux.map[i.wdir, i] * rel.wspd
                wspd.y[i] <- Uy.map[i.wdir, i] * rel.wspd
                # (2,13) ~ (2,13), (2,2,13)
                U.mu[, i] ~ dmnorm(c(wspd.x[i], wspd.y[i]), U.T.obs.array[,, i])
        }
        wspd <- rel.wspd * U.ref
        wdir <- wdirs[i.wdir]
        # prior
        # wind direction
        Mwdir ~ dcat(p.wdir)
        i.wdir <- wdir.Cat[Mwdir]
        # wind speed
        log.rel.wspd ~ dunif(logWspdLower, logWspdUpper)
        rel.wspd <- 10^log.rel.wspd
}
wf.path <- file.path(getwd(), 'windfinder.bug')
write.model(windfinder, wf.path)