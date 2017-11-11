############### STE_wind_JU2003 ###############
### 02construct                             ###
### construct wind finder BUGS/JAGS model   ###
### Date: 2017-11-11                        ###
### By: xf                                  ###
###############################################

library(R2WinBUGS)
windfinder <- function(){
        # likelihood
        for(i in 1:n.valid.Ux){
                wspd.x[i] <- Ux.map[i.wdir, i] * rel.wspd
                Ux.mu[i] ~ dnorm(wspd.x[i], Ux.tau[i])
        }
        for(j in 1:n.valid.Uy){
                wspd.y[j] <- Uy.map[i.wdir, j] * rel.wspd
                Uy.mu[j] ~ dnorm(wspd.y[j], Uy.tau[j])
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