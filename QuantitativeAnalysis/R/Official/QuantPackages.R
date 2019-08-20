####################################################################
# Name: Quantpackages.R
# Description: Install packages and load libraries necessary for
#              quantitative analysis
# Author: Cindy S. Cheung
# Date: August 11, 2019
# Version: 1
####################################################################

####################################################################
# Update R packages
####################################################################
install.packages('installr')
library(installr)
updateR()

####################################################################
# Install packages and load libraries for quantitative analysis
####################################################################
install.packages("dplyr")
install.packages("devtools")
devtools::install_github("joshuaulrich/quantmod")
install.packages("ggplot2")
devtools::install_github("ropensci/plotly")
install.packages('forecast')
install.packages('gridExtra')
install.packages("PerformanceAnalytics")
install.packages('PortfolioAnalytics')
install.packages('ROI')
install.packages('ROI.plugin.quadprog')
install.packages('ROI.plugin.glpk')

library(dplyr)
library(devtools)
library(quantmod)
library(ggplot2)
library(plotly)
library(forecast)
library(gridExtra)
library(PerformanceAnalytics)
library(PortfolioAnalytics)
library(ROI)
library(ROI.plugin.quadprog)
library(ROI.plugin.glpk)
library(foreach)

####################################################################
# Install packages and load libraries for TD Ameritade API
####################################################################
# install.packages('httr')
# install.packages('jsonlite')
# install.packages('magrittr')
# 
# library(httr)
# library(jsonlite)
# library(magrittr)