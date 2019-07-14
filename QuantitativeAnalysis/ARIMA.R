####################################################################
# Creator: Cindy S Cheung
# Script Name: ARIMA
# Purpose: This is side ARIMA script that coincides with DataCamp's
#          "ARIMA Modeling with R".
# Version: 1.0
####################################################################

####################################################################
# Install packages needed to be used in script
####################################################################

# For data manipulaton in data frame objects
install.packages('dplyr')

# Make package development easier--needed this to update quantmod to
# work with the current Yahoo server. Otherwise, quantmod cannot 
# download data from Yahoo.  Also needed this to update plotly to
# plot candlestick charts.
install.packages('devtools')

# Quantitative Financial Modeling Framework Package includes most
# trading functions and strategies
# Update quandmod to the development version created by J. Ulrich
devtools::install_github("joshuaulrich/quantmod")

# For data visualization
install.packages('ggplot2')

# For plotting candlesticks
# Update plotly to the development version created by rOpenSci
devtools::install_github("ropensci/plotly")

####################################################################
# Load package libraries
####################################################################
library(dplyr)
library(devtools)
library(quantmod)
library(ggplot2)
library(plotly)

# Set directory
work_dir <- "C:/Users/cinji/OneDrive/Quantitative Analytics"
setwd(work_dir)

# Extract stock price data of Ferrari from Yahoo
getSymbols("RACE", src = "yahoo", auto.assign = TRUE)

# Examine structure of the stock
str(RACE)
head(RACE)

# Extract closing price of the stock
close <- Cl(RACE)
Date <- index(close)
Price <- coredata(close)

# Extract adjusted closing price
Adjusted <- Ad(RACE)
Adjusted_vec <- coredata(Adjusted)
Adjusted_ts <- ts(Adjusted)

# Plot the closing price of the stock
ggplot(close, aes(x = Date, y = Price)) + 
  geom_line() +
  labs(title = "Closing Price of RACE", 
       X = "Date", 
       y = "Price")

# Plot the Adjusted Closing Price of the stock
ggplot(Adjusted, aes(x = Date, y = Adjusted_vec)) + 
  geom_line() +
  labs(title = "Adjusted Closing Price of RACE", 
       X = "Date", 
       y = "Price")

# Plot candlestick chart for RACE
data.frame(date = index(RACE), coredata(RACE)) %>%
  plot_ly(x = ~Date, type = "candlestick", 
          open = ~RACE.Open, close = ~RACE.Close, 
          high = ~RACE.High, low = ~RACE.Low) %>%
  layout(title = "Candlestick Chart of RACE")

####################################################################
# Find the stock return
# Using adjusted closing price is more accurate than closing price
####################################################################

# Calculate stock price return rate between price(t) and price(t-1)
Returns <- (Adjusted_ts[-1] / Adjusted_ts[-length(Adjusted_ts)]) - 1

# Convert returns from a number vector to a time series
Returns_ts <- ts(Returns)

# Plot returns
plot(Returns_ts)

# Convert prices to log returns
LogReturns <- diff(log(Adjusted_ts))

# Plot LogReturns
plot(LogReturns)

####################################################################
# START OF COURSE
# Differencing
# Takes the difference between the values of a time series at a
# certain time and its preceding value x(t) - x(t - 1).  This 
# removes the trend in a non-stationary time series and coerce it
# to stationary.
####################################################################
install.packages("astsa")

library(astsa)

# Compute the difference of the Adjusted Closing Price
diff_Adjusted <- diff(Adjusted_ts)

# Plot the time series after differencing
plot(diff_Adjusted)

# Take log of Adjusted Closing Price because of heteroscedasticity
# in the time series to help make Adjusted stationary
# Have to Log first, then difference
log_Adjusted <- log(Adjusted_ts)

ggplot(Adjusted, aes(x = Date, y = coredata(log_Adjusted))) + 
  geom_line() +
  labs(title = "Log of Adjusted Closing Price of RACE", 
       X = "Date", 
       y = "Price")

difflog_Adj <- diff(log_Adjusted)

ggplot(Adjusted, aes(x = Date, y = c(0, coredata(difflog_Adj)))) + 
  geom_line() +
  labs(title = "Log of Adjusted Closing Price of RACE", 
       X = "Date", 
       y = "Price")

####################################################################
# Growth Rate or Returns p
# x(t) = (1 + p)*x(t -1)
# p ~ y(t) = log(x(t)) - log(x(t - 1))
####################################################################

# Compute Returns
##difflog_Adjusted <- diff(log_Adjusted)

# Plot the returns of the stock (makes Adjusted stationary)
##plot(difflog_Adjusted)

####################################################################
# ARIMA: Autocorrelation
####################################################################

# ACF on Adjusted Closing Price
acf2(Adjusted_ts)

# ACF on Differenced Adjusted Closing Price
# Results in White Noise which cannot be forecasted
acf2(diff_Adjusted)

# ACF on Differenced Log of Adjusted Closing Price
##acf2(difflog_Adj)

# ACF on Returns
##acf2(difflog_Adjusted)

####################################################################
# Fitting an AR(1) model
####################################################################

# Fit model onto Adjusted Closing Price
sarima(Adjusted_ts, 1, 0, 0)

# Fit model onto Differenced Adjusted Closing Price
sarima(diff_Adjusted, 1, 0, 0)

# Fit model onto Returns
## sarima(difflog_Adjusted, 1, 0, 0)

####################################################################
# Fitting ARIMA(1, 1, 0) model
####################################################################

# Fit model onto Adjusted Closing Price
# Best one so far**
sarima(Adjusted_ts, 1, 1, 0)

# Fit model onto Differenced Adjusted Closing Price
sarima(diff_Adjusted, 1, 1, 0)

# Fit model onto Returns
sarima(difflog_Adjusted, 1, 1, 0)

####################################################################
# Fitting ARIMA(1, 1, 1) model
####################################################################

# Fit model onto Adjusted Closing Price
sarima(Adjusted_ts, 1, 1, 1)

# Fit model onto Differenced Adjusted Closing Price
sarima(diff_Adjusted, 1, 1, 1)

# Fit model onto Returns
sarima(difflog_Adjusted, 1, 1, 1)




sarima(Adjusted_ts, 3, 1, 0)
