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

# Make package development easier--needed this to update quantmod to
# work with the current Yahoo server. Otherwise, quantmod cannot 
# download data from Yahoo
install.packages('devtools')

# Quantitative Financial Modeling Framework Package includes most
# trading functions and strategies
install.packages('quantmod')

####################################################################
# Load package libraries
####################################################################
library(devtools)
library(quantmod)

# Set directory
work_dir <- "C:/Users/cinji/OneDrive/Quantitative Analytics"
setwd(work_dir)

# Update quandmod to the development version created by J. Ulrich
devtools::install_github("joshuaulrich/quantmod")

# Extract stock price data of Ferrari from Yahoo
getSymbols("RACE", src = "yahoo", auto.assign = TRUE)

str(RACE)
head(RACE)
