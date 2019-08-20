####################################################################
# Name: Main script
# Description: Main script for quantitative analysis
# Author: Cindy S. Cheung
# Date: August 11, 2019
# Version: 1
####################################################################

# sys.sleep(10)

####################################################################
# Set working directory
####################################################################

# Working directory
WorkDir <- "C:/Users/cinji/Documents/Quantitative Analysis/R"
setwd(WorkDir)

####################################################################
# Load functions
####################################################################

# Install packages and load libraries
source("QuantPackages.R")

# Load extract price history function
source("PriceHistory.R")

# Load Univariate time series analysis function
source("Univariate.R")

# Load Daily, Weekly, and MOnthly returns function
source("DailyWeeklyMonthlyRTN2.R")

# Load risk-adjusted performance measures
source("RiskInfo.R")

####################################################################
# Quantitative Analysis
####################################################################

# Input desired stock/asset tickers
tickers <- c("XLU", "XLB", "XLC")

# Extract historical price data
# Input: stock tickers as a character vector
# Output: OHLCAd history for each stock as an xts object,
#         Adjusted closing price for each stock collected in one
#         xts object
adjusted <- PriceHistory(tickers)

# Obtain rate of return information
RTN <- DailyWeeklyMonthlyRTN(adjusted)
names(RTN) <- c("dailyRTN", "weeklyRTN", "monthlyRTN")

dailyRTN <- RTN$dailyRTN
weeklyRTN <- RTN$weeklyRTN
monthlyRTN <- RTN$monthlyRTN