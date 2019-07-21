####################################################################
# Creator: Cindy S Cheung
# Script Name: Sector Univariate Time Series Analysis
# Purpose: For every sector, extract/downlaod historical data and 
#          produce univariate plots that evaluates the rate of 
#          return.
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

# Econometric Tools for Performance and Risk Analysis
install.packages("PerformanceAnalytics")

# Arrange ggplot layout
install.packages('gridExtra')

# Plot correlation matrix
install.packages('corrplot')

install.packages('PerformanceAnalytics')
####################################################################
# Load package libraries
####################################################################
library(dplyr)
library(devtools)
library(quantmod)
library(ggplot2)
library(plotly)
library(gridExtra)
library(corrplot)
library(PerformanceAnalytics)

# Set directory
work_dir <- "C:/Users/cinji/OneDrive/Quantitative Analytics"
setwd(work_dir)

####################################################################
# Download Sector ETFs
# Downloaded as xts objects
####################################################################

# A vector of sector ETF tickers
sectorETF <- c("XLB", "XLC", "XLE", "XLF", "XLI", "XLK", "XLP", 
               "XLRE", "XLU", "XLV", "XLY")

# Empty list to store resulting ETF xts objects
sectors_xts <- list()

# Empty list to store resulting ETF univariate plots
sectors_plots <- list()

# For every ETF on the list, download its historical data and 
# produce its univariate plots
for (i in 1:length(sectorETF)) {
  sectors_xts[[i]] <- getSymbols(sectorETF[i], src = "yahoo", 
                                 auto.assign = FALSE, 
                                 return.class = "xts")
  
  sectors_plots <- univariate(sectors_xts[[i]], sectorETF[i])
}

####################################################################
# Multivariate Time Series Analysis
####################################################################

# Create empty xts object to collect all adjusted closing prices
# into one xts object
sectors_Adj <- xts()

# Collect all adjusted closing prices into one xts object
for (i in 1:length(sectors_xts)) {
  
  sectors_Adj <- cbind(sectors_Adj, Ad(sectors_xts[[i]]))
  
}

# Rename columns of sectors_Adj
colnames(sectors_Adj) <- sectorETF

# Omit days in which any ETF had NA
sectors_Adj_omitna <- na.omit(sectors_Adj)

# Plot sector price levels over time
ggplot() + 
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLB, color = "1"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLC, color = "2"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLE, color = "3"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLF, color = "4"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLI, color = "5"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLK, color = "6"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLP, color = "7"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLRE, color = "8"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLU, color = "9"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLV, color = "10"), lwd = 1.2) +
  geom_line(data = sectors_Adj_omitna, aes(x = index(sectors_Adj_omitna), y = XLY, color = "11"), lwd = 1.2) +
  scale_color_manual(labels = sectorETF, values = c("gold1", "springgreen3", "seagreen4", "steelblue1", "royalblue3", "navyblue", 
                                                    "mediumpurple3", "purple4", "violetred3", "firebrick3", "brown1")) +
  scale_fill_discrete(name = "Sectors", labels = c("XLB", "XLC", "XLE", "XLF", "XLI", "XLK", "XLP", 
                                                   "XLRE", "XLU", "XLV", "XLY")) +
  guides(color = guide_legend("Sectors")) +
  labs(x = "Date", y = "Price")

####################################################################
# Analyze weights
####################################################################

# Compute weights for each sector
sector_weights <- sectors_Adj_omitna / rowSums(sectors_Adj_omitna)

# Plot weights
barplot(sector_weights, border = NA, col = brewer.pal(11, name = "Set3"))


# Create a plot in which value and weight can be compared over time
sectors_df <- as.data.frame(sectors_Adj_omitna)
sectors_df$date <- rownames(sectors_df)
sectors_df$date <- as.POSIXct(as.Date(sectors_df$date))
sectors_df <- tidyr::gather(sectors_df, col, val, -date)
ggplot(sectors_df, aes(date, val, fill = col)) + 
  geom_col() + 
  labs(x = "Date", y = "Weight") +
  theme(axis.text.y = element_blank()) +
  scale_fill_manual(name = "Sectors", values = c("gold1", "springgreen3", 
                                               "seagreen4", "steelblue1", 
                                               "royalblue3", "navyblue", 
                                               "mediumpurple3", "purple4", 
                                               "violetred3", "firebrick3", 
                                               "brown1"))

# Plot the weights of each fund over time
sec_weights_df <- as.data.frame(sector_weights)
sec_weights_df$date <- rownames(sec_weights_df)
sec_weights_df$date <- as.POSIXct(as.Date(sec_weights_df$date))
sec_weights_df <- tidyr::gather(sec_weights_df, col, val, -date)
ggplot(sec_weights_df, aes(date, val, fill = col)) + 
  geom_col() +
  labs(x = "Date", y = "Weight") +
  scale_fill_manual(name = "Sectors", values = c("gold1", "springgreen3", 
                                               "seagreen4", "steelblue1", 
                                               "royalblue3", "navyblue", 
                                               "mediumpurple3", "purple4", 
                                               "violetred3", "firebrick3", 
                                               "brown1"))

####################################################################
# Rate of Return Correlation
####################################################################

# Compute sector Rate of Returns
sectors_RoR <- ROC(sectors_Adj_naomit)
sectors_RoR <- sectors_RoR[-1,]

# Compute correlation matrix
sectors_cor <- cor(na.omit(sectors_RoR), method = "pearson")

# Plot correlation scatter plots
pairs(as.data.frame(na.omit(sectors_RoR)))

# Visualize correlation matrix
corrplot(sectors_cor, method = "number")

####################################################################
# Plot cumulative returns
####################################################################

# Initial value of sectors
sectors1 <- sectors_Adj_omitna[1,]

# Cumulative Return of Each Sector Part 1
XLB_cumrtn <- sectors_Adj_omitna$XLB / as.numeric(sectors1$XLB)
XLC_cumrtn <- sectors_Adj_omitna$XLC / as.numeric(sectors1$XLC)
XLE_cumrtn <- sectors_Adj_omitna$XLE / as.numeric(sectors1$XLE)
XLF_cumrtn <- sectors_Adj_omitna$XLF / as.numeric(sectors1$XLF)
XLI_cumrtn <- sectors_Adj_omitna$XLI / as.numeric(sectors1$XLI)
XLK_cumrtn <- sectors_Adj_omitna$XLK / as.numeric(sectors1$XLK)
XLP_cumrtn <- sectors_Adj_omitna$XLP / as.numeric(sectors1$XLP)
XLRE_cumrtn <- sectors_Adj_omitna$XLRE / as.numeric(sectors1$XLRE)
XLU_cumrtn <- sectors_Adj_omitna$XLU / as.numeric(sectors1$XLU)
XLV_cumrtn <- sectors_Adj_omitna$XLV / as.numeric(sectors1$XLV)
XLY_cumrtn <- sectors_Adj_omitna$XLY / as.numeric(sectors1$XLY)

# Cumulative Return of Each Sector Part 2
sec_cumrtn <- cbind(XLB_cumrtn, XLC_cumrtn, XLE_cumrtn, XLF_cumrtn, 
                    XLI_cumrtn, XLK_cumrtn, XLP_cumrtn, XLRE_cumrtn, 
                    XLU_cumrtn, XLV_cumrtn, XLY_cumrtn)

ggplot() + 
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLB, color = "1"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLC, color = "2"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLE, color = "3"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLF, color = "4"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLI, color = "5"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLK, color = "6"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLP, color = "7"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLRE, color = "8"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLU, color = "9"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLV, color = "10"), lwd = 1.2) +
  geom_line(data = sec_cumrtn, aes(x = index(sec_cumrtn), y = XLY, color = "11"), lwd = 1.2) +
  scale_color_manual(labels = sectorETF, values = c("gold1", "springgreen3", "seagreen4", "steelblue1", "royalblue3", "navyblue", 
                                                    "mediumpurple3", "purple4", "violetred3", "firebrick3", "brown1")) +
  scale_fill_discrete(name = "Sectors", labels = c("XLB", "XLC", "XLE", "XLF", "XLI", "XLK", "XLP", 
                                                   "XLRE", "XLU", "XLV", "XLY")) +
  guides(color = guide_legend("Sectors")) +
  labs(x = "Date", y = "Price")
