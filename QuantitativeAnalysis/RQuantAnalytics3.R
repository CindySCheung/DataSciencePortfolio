####################################################################
# Creator: Cindy S Cheung
# Script Name: RQuantAnalytics
# Purpose: This is the first R script in learning how to use R to 
#          evaluate stock investment. This is the core script at its
#          first stages, so there are no functions yet.
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

# Plot the closing price of the stock
ggplot(close, aes(x = Date, y = Price)) + 
  geom_line() +
  labs(title = "Closing Price of RACE", 
       X = "Date", 
       y = "Price")

# Plot candlestick chart for RACE
data.frame(date = index(RACE), coredata(RACE)) %>%
  plot_ly(x = ~Date, type = "candlestick", 
          open = ~RACE.Open, close = ~RACE.Close, 
          high = ~RACE.High, low = ~RACE.Low) %>%
  layout(title = "Candlestick Chart of RACE")

####################################################################
# White Noise Model
# The arima function estimates are very close to the sample mean
# and sample variance.
####################################################################

# Fit the white noise model to closing price using arima
arima(close, order = (c(0, 0, 0)))

# Sample mean
mean(close)

# sample variance
var(close)

####################################################################
# Random Walk Model
# 
####################################################################

# Difference close data
close_diff <- diff(close)

# Plot differenced close data
ts.plot(close_diff)

# Fit white noise model to the differenced close data
model_wn <- arima(x = close_diff, order = c(0, 0, 0))

####################################################################
# Find the stock return
# Using adjusted closing price is more accurate than closing price
####################################################################

# Extract adjusted closing price
Adjusted <- Ad(RACE)

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
# Charactistics of the returns time series
####################################################################

# Mean of Percentage Returns
mean(Returns*100)

# Variance of Percentage Returns
var(Returns*100)

# Standard Deviation of Percentage Returns
sd(Returns*100)

# Histogram of Percentage Returns
hist(Returns*100)

# QQ Plot of Percentage Returns
qqnorm(Returns*100)
qqline(Returns*100)

####################################################################
# Autocorrelation
# Assesses whether a time series is dependent on its past
# Parameters can be altered to see camparisons
####################################################################

acf(Adjusted_ts, lag.max = 310, plot = FALSE)

####################################################################
# Autoregression Model Estimation and Forecasting
####################################################################

# Forecast h-steps ahead
h <- 50

# Fit AR model to adjusted closing price
AR <- arima(Adjusted_ts, order = c(1, 0, 0))

# MOdels the data in a reproducible fashion
# Can predict future observations based on fitted data
ts.plot(Adjusted_ts)
AR_fitted <- Adjusted_ts - residuals(AR)
points(AR_fitted, type = "l", col = 2, lty = 2)

# Make forecasts from an estimated AR model
# predict_AR <- predict(AR)

# Get the 1-step (one day later) forecast
# predict_AR$pred[1]

# Predict to make 1-step (one day later) through h-step (h days 
# later) forecasts
predict_AR <- predict(AR, n.ahead = h)

# Plot adjusted closing price plus the forecast and 95% prediction 
# intervals

# Plot the adjusted closing price with extended time
ts.plot(Adjusted_ts, 
        xlim = c(length(Adjusted_ts) - 100, 
                 length(Adjusted_ts) + h), 
        ylim = c(last(Adjusted_ts) - 100, 
                 last(Adjusted_ts) + 100))

# Extract forecast value
AR_forecast <- predict_AR$pred

# Extract forecast standard error
AR_forecast_se <- predict_AR$se

# Plot the forecast and standard error which results in the 95%
# prediction interval
points(AR_forecast, type = "l", col = 2)
points(AR_forecast - 2*AR_forecast_se, type = "l", col = 2, lty = 2)
points(AR_forecast + 2*AR_forecast_se, type = "l", col = 2, lty = 2)

####################################################################
# Simple Moving Average Estimation and Forecasting
####################################################################

# Forecast h-steps ahead
h <- 50

# Fit SMA model to adjusted closing price
SMA <- arima(Adjusted_ts, order = c(0, 0, 1))

# MOdels the data in a reproducible fashion
# Can predict future observations based on fitted data
ts.plot(Adjusted_ts)
SMA_fitted <- Adjusted_ts - residuals(SMA)
points(SMA_fitted, type = "l", col = 2, lty = 2)

# Predict to make 1-step (one day later) through h-step (h days 
# later) forecasts
predict_SMA <- predict(SMA, n.ahead = h)

# Plot adjusted closing price plus the forecast and 95% prediction 
# intervals

# Plot the adjusted closing price with extended time
ts.plot(Adjusted_ts, 
        xlim = c(length(Adjusted_ts) - 200, 
                 length(Adjusted_ts) + h), 
        ylim = c(last(Adjusted_ts) - 100, 
                 last(Adjusted_ts) + 100))

# Extract forecast value
SMA_forecast <- predict_SMA$pred

# Extract forecast standard error
SMA_forecast_se <- predict_SMA$se

# Plot the forecast and standard error which results in the 95%
# prediction interval
points(SMA_forecast, type = "l", col = 2)
points(SMA_forecast - 2*AR_forecast_se, type = "l", col = 2, lty = 2)
points(SMA_forecast + 2*AR_forecast_se, type = "l", col = 2, lty = 2)

####################################################################
# Compare AR and SMA models
####################################################################

# Correlation between AR fitted values and SMA fitted values
cor(AR_fitted, SMA_fitted)

AIC(AR)
AIC(SMA)
BIC(AR)
BIC(SMA)