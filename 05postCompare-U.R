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
i.sensor <- 13
n.post <- nrow(mcmc)
## calculate predicted velocity at wind sensors
Ux.mean.post <- Ux.map[mcmc$i.wdir,] * mcmc$wspd / U.ref  # posterior predictive mean Ux
Uy.mean.post <- Uy.map[mcmc$i.wdir,] * mcmc$wspd / U.ref
k.mean.post <- k.map[mcmc$i.wdir,] * mcmc$wspd^2 / U.ref^2 # posterior predictive k

Ux.post <- rnorm(n.post, Ux.mean.post[,i.sensor], sqrt(2/3 * k.mean.post[,i.sensor]))
Uy.post <- rnorm(n.post, Uy.mean.post[,i.sensor], sqrt(2/3 * k.mean.post[,i.sensor]))
U.post.i <- data.frame(x = Ux.post, y=Uy.post)
U.obs.i <- data.frame(x=Ux.obs[,i.sensor], y=Uy.obs[,i.sensor])
## plot 
commonTheme = list(labs(color="Density",fill="Density",
                        x="RNA-seq Expression",
                        y="Microarray Expression"),
                   theme_bw(),
                   theme(legend.position=c(0,1),
                         legend.justification=c(0,1)))
g1 <- ggplot() + 
        #geom_density2d(data=U.post.i,aes(x, y, colour=..level..)) + 
        geom_point(data=U.post.i, aes(x, y), col = 'red', alpha = 0.01) +
        scale_colour_gradient(low="green",high="red") + 
        scale_x_continuous(limits = c(-6,6)) +
        scale_y_continuous(limits = c(-6,6)) +
        geom_point(data=U.obs.i, aes(x, y), col = 'green',alpha = 0.5) + commonTheme 
plot(g1)