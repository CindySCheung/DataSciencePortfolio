####################################################################
# Name: Univariate.R
# Description: Plots various charts for univariate time series
#              analysis
# Author: Cindy S. Cheung
# Date: August 11, 2019
# Version: 1
####################################################################

# asset = adjusted closing price in the form of an xts object
univariate <- function(asset, asset_ticker) {
  
  # Plot adjusted closing price of asset
  plot1 <- ggplot(asset, aes(x = index(asset), y = coredata(asset))) + 
    geom_line() + 
    labs(title = paste("Adjusted Closing Price of ", asset_ticker), 
         x = "Date", y = "Price")

  # Compute Rate of Return
  RoR <- dailyReturn(asset)
  
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
