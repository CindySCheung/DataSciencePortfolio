####################################################################
# Creator: Cindy S Cheung
# Script Name: Portfolio Analysis on Sectors
# Purpose: This is the first R script in learning how to use R to 
#          evaluate sector portfolio performance.
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

# Design layout of ggplots
install.packages('gridExtra')

# Download color palettes
install.packages('RColorBrewer')

# Works with time series
install.packages('tseries')

install.packages('ggrepel')

####################################################################
# Load package libraries
####################################################################
library(dplyr)
library(devtools)
library(quantmod)
library(ggplot2)
library(plotly)
library(gridExtra)
library(RColorBrewer)
library(tseries)
library(ggrepel)

# Set directory
work_dir <- "C:/Users/cinji/OneDrive/Quantitative Analytics"
setwd(work_dir)

####################################################################
# Create New Portfolio
# N = 5 Total Investments
# Balance = $10,000
# Equally weighted
####################################################################

# Total balance of portfolio
balance <- 10000

# Number of investments
N <- 11

# Weight of each investment; Equally weighted
eq_weights <- rep(1/N, N)

# Create a portfolio using buy and hold
PFBuyHold <- Return.portfolio(R = sectors_RoR, weights = eq_weights, 
                              verbose = TRUE)

# Create a portfolio using monthly rebalancing
PFMonRebal <- Return.portfolio(R = sectors_RoR, weights = eq_weights, 
                              rebalance_on = "months", verbose = TRUE)

# Create End of Period Weights
EOPWeightsBuyHold <- PFBuyHold$EOP.Weight

# Create eop_weight_rebal
EOPWeightsRebal <- PFMonRebal$EOP.Weight

par(mfrow = c(2, 1), mar = c(2, 4, 2, 2))
plot.zoo(PFBuyHold$returns)
plot.zoo(PFMonRebal$returns)

####################################################################
# Plot End of Period Weight Plots
####################################################################

# Empty list to store resulting ETF univariate plots
EOPSecWeightPlots <- list()

# Plot End of Period Weights for each asset
EOPWeightsPlots <- function(EOPWeightsBuyHold, EOPWeightsRebal) {
  
  # Construct plot
  plot1 <- ggplot() + 
    geom_line(data = EOPWeightsBuyHold, aes(x = index(EOPWeightsBuyHold), y = coredata(EOPWeightsBuyHold), color = "1"), lwd = 1.2) +
    geom_line(data = EOPWeightsRebal, aes(x = index(EOPWeightsRebal), y = coredata(EOPWeightsRebal), color = "2"), lwd = 1.2) +
    scale_color_manual(labels = c("Buy and Hold", "Rebalance Monthly"), values = c("maroon1", "turquoise3")) +
    scale_fill_discrete(name = "Stretagy") +
    guides(color = guide_legend("Strategy")) +
    labs(x = "Date", y = "Weight")
  
  # Design plot layout on page
  layout <- rbind(c(1, 1), c(1, 1))
  grid.arrange(plot1, layout_matrix = layout)
  
}

# Plot End of Period weights for each sector ETF and store plots in
# a list
for (i in 1:length(sectorETF)) {
  
  EOPSecWeightPlots <- EOPWeightsPlots(EOPWeightsBuyHold[,i], EOPWeightsRebal[,i])
}

####################################################################
# Explore monthly returns
####################################################################

# Extract monthly adjusted closing price
Monthly_Adjusted <- sectors_Adj_omitna[head(endpoints(sectors_Adj_omitna$XLB, on = "months", k = 1) + 1, -1),]

# Create Monthly Rate of Return
Monthly_RoR <- Return.calculate(Monthly_Adjusted)
Monthly_RoR <- na.omit(Monthly_RoR)

# Plot Monthly Rate of Returns
  ggplot() + 
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLB, color = "1"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLC, color = "2"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLE, color = "3"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLF, color = "4"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLI, color = "5"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLK, color = "6"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLP, color = "7"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLRE, color = "8"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLU, color = "9"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLV, color = "10"), lwd = 1.2) +
    geom_line(data = Monthly_RoR, aes(x = index(Monthly_RoR), y = XLY, color = "11"), lwd = 1.2) +
    scale_color_manual(labels = sectorETF, values = c("gold1", "springgreen3", "seagreen4", "steelblue1", "royalblue3", "navyblue", 
                                                      "mediumpurple3", "purple4", "violetred3", "firebrick3", "brown1")) +
    scale_fill_discrete(name = "Sectors", labels = c("XLB", "XLC", "XLE", "XLF", "XLI", "XLK", "XLP", 
                                                     "XLRE", "XLU", "XLV", "XLY")) +
    guides(color = guide_legend("Sectors")) +
    labs(x = "Date", y = "Price")  
  
# Put Monthly Returns in a table
Monthly_ROR_Table <- table.CalendarReturns(Monthly_RoR)
  
# Calculate mean of each sector
AvgMonthlyRoR <- colMeans(Monthly_RoR, na.rm = TRUE)
  
# Use geometric mean for returns because actual amount is irrelevant
GeoAvgMonthlyRoR <- mean.geometric(Monthly_RoR)[1,]
  
# Calculate standard deviation of each sector
SDMonthlyRoR <- apply(Monthly_RoR, 2, sd)

####################################################################
# Explore Sharpe Ratio
####################################################################

# Create Risk-Free Rate
Risk_Free <- 0

# Calculate Sharpe Ratio
SecSharpeRatio <- GeoAvgMonthlyRoR / SDMonthlyRoR

# Calculate Annualized Means and Volitilities
AnnualizedRoRStats <- table.AnnualizedReturns(Monthly_RoR)

####################################################################
# Skewness of Returns
# A negative skewness indicates that large negative returns occur 
# more often than large positive ones, and vice versa.
# Kurtosis will be positive if there are fat tails in your 
# distribution. This means that large positive or negative returns 
# will happen more often than can be assumed under a normal 
# distribution.
####################################################################

# Skewness of daily return of each sector
skewness(sectors_Adj_omitna)

# Skewness of monthly return of each sector
skewness(Monthly_Adjusted)

# Kurtosis of daily return of each sector
kurtosis(sectors_Adj_omitna)

# Kurtosis of monthly return of each sector
kurtosis(Monthly_Adjusted)

####################################################################
# Explore downside risk measures
####################################################################

# Calculate SemiDeviation of each sector
SecSemiDev <- SemiDeviation(Monthly_RoR)

# Calculate the value at risk of each sector
SecVaR <- VaR(Monthly_RoR, p = 0.05)

# Calculate the expected shortfall of each sector
SecES <- ES(Monthly_RoR, p = 0.05)

####################################################################
# Compute drawdowns of each sector
####################################################################

# Create empty list to store drawdown dataframes
SecDrawdowns <- list()

# Generate drawdown tables for each sector
for(i in 1:length(sectorETF)) {
  
    SecDrawdowns[[(2*i)-1]] <- sectorETF[i]
    SecDrawdowns[[2*i]] <- table.Drawdowns(sectors_RoR[,i])

}

# Plot of drawdowns
chart.Drawdown(sectors_RoR)

####################################################################
# Plot Risk and Reward Diagram
####################################################################

ggplot() +
  geom_text(aes(x = SDMonthlyRoR, y = GeoAvgMonthlyRoR, label = sectorETF)) +
  geom_hline(yintercept = 0) +
  labs(x = "Volitility (StdDev)", y = "Mean Monthly Return")

####################################################################
# Covariance
####################################################################

diag(SDMonthlyRoR^2)
cov_matrix <- cov(Monthly_RoR)
cor_matrix <- cor(Monthly_RoR)
all.equal(cov_matrix[1,2], cor_matrix[1,2] * SDMonthlyRoR[[1]] * SDMonthlyRoR[[2]])

####################################################################
# Calculate Portfolio Mean and Variance
####################################################################

# Create a weight matrix
WeightMat <- as.matrix(eq_weights)

# Create a return matrix
GeoAvgRoRMat <- as.matrix(GeoAvgMonthlyRoR)

# Portfolio mean monthly return
t(WeightMat) %*% GeoAvgRoRMat

# portfolio volitility
sqrt(t(WeightMat) %*% cov_matrix %*% WeightMat)

####################################################################
# Portfolio Risk/Volitility Budget
####################################################################

# Create volitility budget
vol_budget <- StdDev(Monthly_RoR, portfolio_method = "component", weights = eq_weights)

# Make a table of weights and risk contribution
weights_percrisk <- cbind(eq_weights, vol_budget$pct_contrib_StdDev)
colnames(weights_percrisk) <- c("weights", "perc vol contrib")

####################################################################
# MOdern Portfolio Theory
####################################################################

# Create a vector of row means
PortMOnRtn <- rowMeans(Monthly_RoR)

# Cast the numeric vector back to an xts object
PortMOnRtn <- xts(PortMOnRtn, order.by = time(Monthly_RoR))

# Plot PortMOnRtn
ggplot(PortMOnRtn, aes(x = index(PortMOnRtn), y = coredata(PortMOnRtn))) +
  geom_line()

####################################################################
# Optimize portfolio weights (Mean-Variance Efficient)
####################################################################

# Create an optimized portfolio of returns
# Its default implementation finds the mean-variance efficient 
# portfolio weights under the constraint that the portfolio return 
# equals the return on the equally-weighted portfolio.
OptPortRtn <- portfolio.optim(Monthly_RoR)

# Create pf_weights
PFWeights <- OptPortRtn$pw

# Assign asset names
names(PFWeights) <- colnames(Monthly_RoR)

# Select optimum weights opt_weights
OptPortWeights <- PFWeights[PFWeights >= 0.01]

# Bar plot of opt_weights
OptPortWeights_df <- as.data.frame(OptPortWeights)
ggplot(OptPortWeights_df, aes(x = row.names(OptPortWeights_df), y = OptPortWeights)) +
  geom_bar(stat = "identity") +
  labs(title = "Optimal Portfolio Weights", x = "Sectors", y = "Weight")

# Print expected portfolio return and volatility
OptPortRtn$pm
OptPortRtn$ps

####################################################################
# Optimize portfolio weights (assign target return)
####################################################################

# Create portfolio with target return of average returns 
PFTarMean <- portfolio.optim(Monthly_RoR, pm = mean(Monthly_RoR))

# Create portfolio with target return 10% greater than average returns
PFTar10 <- portfolio.optim(Monthly_RoR, pm = 1.3 * mean(Monthly_RoR))

# Print the standard deviations of both portfolios
PFTarMean$ps
PFTar10$ps

# Calculate the proportion increase in standard deviation
(PFTar10$ps - PFTarMean$ps) / (PFTarMean$ps)

# Extract weights
PFWeights10 <- PFTar10s$pw
names(PFWeights10) <- colnames(Monthly_RoR)

# Select optimum weights opt_weights
OptPortWeights10 <- PFWeights10[PFWeights10 >= 0.01]

# Bar plot of opt_weights
OptPortWeights10_df <- as.data.frame(OptPortWeights10)
ggplot(OptPortWeights10_df, aes(x = row.names(OptPortWeights10_df), y = OptPortWeights10)) +
  geom_bar(stat = "identity") +
  labs(title = "Optimal Portfolio Weights", x = "Sectors", y = "Weight")

####################################################################
# Optimize portfolio weights (impose weight constraints)
####################################################################

MaxWeight1 <- rep(1, ncol(Monthly_RoR))
MaxWeight2 <- rep(0.2, ncol(Monthly_RoR))
MaxWeight3 <- rep(0.1, ncol(Monthly_RoR))
MaxWeight4 <- rep(0.05, ncol(Monthly_RoR))

# Create an optimum portfolio with max weights of 100%
opt1 <- portfolio.optim(Monthly_RoR, reshigh = MaxWeight1)

# Create an optimum portfolio with max weights of 20%
opt2 <- portfolio.optim(Monthly_RoR, reshigh = MaxWeight2)

# Create an optimum portfolio with max weights of 10%
opt3 <- portfolio.optim(Monthly_RoR, reshigh = MaxWeight3)

# Create an optimum portfolio with max weights of 5%
opt4 <- portfolio.optim(Monthly_RoR, reshigh = MaxWeight4)

# Calculate how many assets have a weight that is greater than 1% for each portfolio
sum(opt1$pw > .01)
sum(opt2$pw > .01)
sum(opt3$pw > .01)
sum(opt4$pw > .01)

# Print portfolio volatilites 
opt1$ps
opt2$ps
opt3$ps
opt4$ps

####################################################################
# Efficient Frontier
####################################################################

# Calculate each sectors' mean returns
MeanSecRtn <- colMeans(Monthly_RoR)

# Create a grid of target values
grid <- seq(from = 0.01, to = max(MeanSecRtn), length.out = 50)

# Create empty vectors to store means and deviations
PFMean <- rep(NA, length(grid))
PFSD <- rep(NA, length(grid))

# Create an empty matrix to store weights
WeightsMat <- matrix(NA, 50, length(sectorETF))

# Calculate potential portfolio means, volitility, and weights
for(i in 1:length(grid)) {
  opt <- portfolio.optim(x = Monthly_RoR, pm = grid[i])
  PFMean[i] <- opt$pm
  PFSD[i] <- opt$ps
  WeightsMat[i,] <- opt$pw
}

colnames(WeightsMat) <- sectorETF

####################################################################
# Minimum Variance and Maximum Sharpe Ratio Portfolio
####################################################################

# Create weights_minvar as the portfolio with the least risk
MinVarWeights <- WeightsMat[PFSD == min(PFSD), ]

# Calculate the Sharpe ratio
PFSharpe <- (PFMean - Risk_Free) / PFSD

# Create MaxSharpeWeights as the portfolio with the maximum Sharpe ratio
MaxSharpeWeights <- WeightsMat[PFSharpe == max(PFSharpe),]

# Create bar plot of MinVarWeights
MinVarWeights_df <- as.data.frame(MinVarWeights)
ggplot(MinVarWeights_df, aes(x = row.names(MinVarWeights_df), y = MinVarWeights)) +
  geom_bar(stat = "identity") +
  labs(title = "Optimal Portfolio Weights", x = "Sectors", y = "Weight")

# Create bar plot of MaxSharpeWeights_df
MaxSharpeWeights_df <- as.data.frame(MaxSharpeWeights)
ggplot(MaxSharpeWeights_df, aes(x = row.names(MaxSharpeWeights_df), y = MaxSharpeWeights)) +
  geom_bar(stat = "identity") +
  labs(title = "Optimal Portfolio Weights", x = "Sectors", y = "Weight")

####################################################################
# Backtesting (Split-Sample Evaluation)
####################################################################

# Create training set
train <- window(sectors_RoR, start = "2018-06-19", end = "2019-04-30")

# Create test set
test <- window(sectors_RoR, start = "2019-05-01", end = "2019- 07-21")

# Create vector of max weights
BTMaxWeights <- rep(0.50, ncol(sectors_RoR))

# Create portfolio with estimation sample 
PFTrain <- portfolio.optim(train, reshigh = BTMaxWeights)

# Create portfolio with evaluation sample
PFTest <- portfolio.optim(test, reshigh = BTMaxWeights)

# Create a scatter plot with evaluation portfolio weights on the vertical axis
# If portfolio weights are identical, they should be on the 45 degree line.
plot(PFTrain$pw, PFTest$pw)
abline(a = 0, b = 1, lty = 3)

ggplot() +
  geom_point(aes(x = PFTrain$pw, y = PFTest$pw)) +
  geom_text_repel(aes(x = PFTrain$pw, y = PFTest$pw, label = sectorETF)) +
  geom_abline(intercept = 0, slope = 1)

####################################################################
# Backtesting (Out of Sample Performance Evaluation)
####################################################################

# Compute returns of the training set
TrainRtn <- Return.portfolio(train, PFTrain$pw, rebalance_on = "months")


# Compute returns of the testing set
TestRtn <- Return.portfolio(test, PFTrain$pw, rebalance_on = "months")

# Table results of Training Return
table.AnnualizedReturns(TrainRtn)

# Table results of Testing Return
table.AnnualizedReturns(TestRtn) 