####################################################################
# Name: PriceHistory.R
# Description: A function to extract price history information from
#              Yahoo Finance
# Author: Cindy S. Cheung
# Date: August 11, 2019
# Version: 1
####################################################################

####################################################################
# Download Stock Assets
# Downloaded as xts objects
# Plot stock charts as line graphs
####################################################################

# A vector of stock tickers
# No more than 10 for best results
PriceHistory <- function(tickers) {

  # Empty xts to store resulting adjusted closing prices
  adjusted <- xts()
  
  # Empty list to store resulting stock time series plots
  stocks_plots <- list()
  
  # Download historical price data
  getSymbols(tickers, src = "yahoo", 
                    auto.assign = TRUE, 
                    return.class = "xts")
  
  # Extract the adjusted closing price of each stock and collect the
  # in one xts object
  for (i in 1:length(tickers)) {
    adjusted <- cbind(adjusted, Ad(get(tickers[i])))
  }

  # Rename columns to tickers
  colnames(adjusted) <- tickers

  # Produce Univariate time series analysis plots
  for (i in 1:length(tickers)) {
  stocks_plots <- univariate(adjusted[,i], tickers[i])
  }
  
  return(adjusted)
}