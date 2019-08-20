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
