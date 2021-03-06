############### STE_wind_JU2003 ###############
### 05postCompare-U                         ###
### posterior predictive comparison of      ###
### predicted velocity and measured ones    ###
### Date: 2017-11-13                        ###
### By: xf                                  ###
###############################################

## header
library(ggplot2)
library(tmvtnorm)

## settings
i.sensor <- 3
n.post <- nrow(mcmc)
## calculate posterior predicted velocity at wind sensors
Ux.mean.post <- Ux.map[mcmc$i.wdir,] * mcmc$wspd / U.ref  # posterior predictive Ux
Uy.mean.post <- Uy.map[mcmc$i.wdir,] * mcmc$wspd / U.ref
k.mean.post <- k.map[mcmc$i.wdir,] * mcmc$wspd^2 / U.ref^2 # posterior predictive k

Ux.post <- rnorm(n.post, Ux.mean.post[,i.sensor], sqrt(2/3 * k.mean.post[,i.sensor])) # Ux +- sd
Uy.post <- rnorm(n.post, Uy.mean.post[,i.sensor], sqrt(2/3 * k.mean.post[,i.sensor]))

U.post.i <- data.frame(x = Ux.post, y=Uy.post)
U.obs.i <- data.frame(x=Ux.obs[,i.sensor], y=Uy.obs[,i.sensor])

## calculate mean and sd of post.pre and obs
U.post.mean.i <- t(apply(U.post.i, 2, mean)) # posterior mean
U.post.sd.i <- t(apply(U.post.i, 2, sd))
U.obs.mean.i <- t(apply(U.obs.i, 2, mean))
U.obs.sd.i <- t(apply(U.obs.i, 2, sd))
U.mean_sd.i <- as.data.frame(cbind(U.post.mean.i, U.post.sd.i, U.obs.mean.i, U.obs.sd.i))
colnames(U.mean_sd.i) <- c('postX.mean', 'postY.mean', 'postX.sd', 'postY.sd',
                            'obsX.mean', 'obsY.mean', 'obsX.sd', 'obsY.sd')

## compare post.mean and obs.mean
U.mean_sd.i$postU <- with(U.mean_sd.i, sqrt(postX.mean^2+postY.mean^2))
U.mean_sd.i$obsU <- with(U.mean_sd.i, sqrt(obsX.mean^2+obsY.mean^2))
print(U.mean_sd.i)
## plot 
commonTheme <- list(labs(color="Density",fill="Density",
                        x="RNA-seq Expression",
                        y="Microarray Expression"))
#                   theme_bw(),
#                   theme(legend.position=c(0,1),
#                         legend.justification=c(0,1)))
post.col <- 'red'
obs.col <- 'blue'
g1 <- ggplot() + 
        #geom_density2d(data=U.post.i,aes(x, y, colour=..level..)) + 
        geom_point(data = U.post.i, aes(x, y), col = post.col, alpha = 0.01) +
        scale_colour_gradient(low = "green", high = "red") + 
        geom_point(data = U.obs.i, aes(x, y), col = obs.col, alpha = 0.5) +
        geom_point(data = U.mean_sd.i, aes(postX.mean, postY.mean), size = 3, col = post.col)+
        geom_point(data = U.mean_sd.i, aes(obsX.mean, obsY.mean), size = 3, col = obs.col)+
        geom_errorbar(data = U.mean_sd.i, aes(x = postX.mean, ymin = postY.mean - postY.sd, ymax = postY.mean + postY.sd),col = post.col)+
        geom_errorbarh(data = U.mean_sd.i, aes(x = postX.mean, y = postY.mean, xmin = postX.mean - postX.sd, xmax = postX.mean + postX.sd),col = post.col)+
        geom_errorbar(data = U.mean_sd.i, aes(x = obsX.mean, ymin = obsY.mean - obsY.sd, ymax = obsY.mean + obsY.sd),col = obs.col)+
        geom_errorbarh(data = U.mean_sd.i, aes(x = obsX.mean, y = obsY.mean, xmin = obsX.mean - obsX.sd, xmax = obsX.mean + obsX.sd),col = obs.col)+
        scale_x_continuous(limits = c(-6,6)) +
        scale_y_continuous(limits = c(-6,6)) +
        commonTheme 
plot(g1)