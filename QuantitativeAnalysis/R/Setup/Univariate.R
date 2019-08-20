install.packages('ggplot2')
install.packages('gridExtra')

library(ggplot2)
library(gridExtra)

# asset in the form of xts object
univariate <- function(asset, asset_ticker) {
  
  # Plot adjusted closing price of asset
  plot1 <- ggplot(Ad(asset), aes(x = index(asset), y = coredata(Ad(asset)))) + 
    geom_line() + 
    labs(title = paste("Adjusted Closing Price of ", asset_ticker), 
         x = "Date", y = "Price")
  
  # deparse(substitute(asset))

# Compute Rate of Return with ROC (Rate of Change) 
# ROC (Rate of Change) = Percentage difference
RoR <- ROC(Ad(asset))

# Plot density histogram and line for Rate of Return
plot2 <- ggplot(RoR, aes(x = coredata(RoR))) + 
  geom_histogram(aes(y = ..density..), 
                 color = "black", fill = "white") +
  geom_density(size = 1.2, alpha = .1, 
               color = "#6666FF", fill = "#6666FF") +
  labs(title = "Return Distribution", 
       x = "Rate of Return", y = "Density")

# Box and whisker plot for Rate of Return
plot3 <- ggplot(RoR, aes(y = RoR)) +
  geom_boxplot() +
  coord_flip()

# Plot ACF and PACF Autocorrelation on Rate of Return
plot4 <- ggAcf(RoR)
plot5 <- ggPacf(RoR)

# Plot QQ plot of Rate of Return
plot6 <- qplot(data = RoR, sample = coredata(RoR)) + 
  stat_qq_line(size = 1.2, color = "red") +
  labs(title = "QQ Plot of Rate of Return", 
       x = "Theorical Quantiles", y = "Sample Quantiles")

# Arrange plot layout
layout <- rbind(c(1, 1), c(2, 4), c(3, 5), c(6, NA))
grid.arrange(plot1, plot2, plot3, plot4, plot5, plot6, 
             layout_matrix = layout)
}
