## test sd of widr and wspd, Ux and Uy
library(MASS)
library(ggplot2)
i.sensor <- 8
U.obs.i <- data.frame(x=Ux.obs[,i.sensor], y=Uy.obs[,i.sensor])

# Ux and Uy
mean <- colMeans(U.obs.i)
covMat <- cov(U.obs.i)
sd1 <- sd(U.obs.i[,1])
sd2 <- sd(U.obs.i[,2])
U <- mvrnorm(1000, mean, covMat)
Ux <- rnorm(1000, mean[1], sd1)
Uy <- rnorm(1000, mean[2], sd2)

df <- data.frame(U,Ux,Uy)
g2 <- ggplot() +
        geom_point(data = U.obs.i, aes(x, y), col = obs.col, alpha = 0.5) +
        geom_point(data = df, aes(x, y), col = 'red', alpha = 0.3) +
        geom_point(data = df, aes(Ux, Uy), col = 'green', alpha = 0.3) +
        scale_x_continuous(limits = c(-6,6)) +
        scale_y_continuous(limits = c(-6,6))
plot(g2)

l1 <- lapply(Ux.obs, as.vector)
l2 <- lapply(Uy.obs, as.vector)
l12 <- mapply(cbind, l1, l2)
covMat <- lapply(l12, cov)
