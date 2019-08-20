####################################################################
# Name: Benchmark.R
# Description: Calculate returns for Benchmark which is the S&P 500
#              (SPY)
# Author: Cindy S. Cheung
# Date: August 14, 2019
# Version: 1
####################################################################

# Input desired stock/asset tickers
bench <- c("SPY")

# Extract historical price data
# Input: stock tickers as a character vector
# Output: OHLCAd history for each stock as an xts object,
#         Adjusted closing price for each stock collected in one
#         xts object
bench_adj <- PriceHistory(bench)


# Obtain rate of return information
benchRTN <- DailyWeeklyMonthlyRTN(bench_adj)
names(benchRTN) <- c("dailyRTN", "weeklyRTN", "monthlyRTN")