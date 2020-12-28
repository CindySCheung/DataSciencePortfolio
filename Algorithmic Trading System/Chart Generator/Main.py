########################################################################################################################
# Name: Main Chart Generator
# Author: Cindy S Cheung
# Description: This script is the main terminal of the Stock Chart Generator.  This includes all functions and parts
#              involved in the process.  It imports the User Interface file to ask the user for the stock, the Financial
#              Data file to load financial data for the specified stock, and the Chart Generator file as a bundle.
#              Program can be executed from beginning to end in one single file.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

import pandas as pd
import UserInterface as ui
import LoadFinancialDataYahoo as lfd
import ChartGenerator as cg

########################################################################################################################
# Execute Program
########################################################################################################################

def main():
    # Widen the console to display more columns
    pd.options.display.width = 0

    # Execute the user interface to retrieve the stock ticker to be used for the rest of the program
    Ticker, EMAperiod, TRIXperiod, TRIXSignalperiod, RSIperiod = ui.UserInterface()

    #  Download stock price data
    StockDF = lfd.LoadFinancialData(Ticker)

    # Draw candlestick chart with technical indicators for chosen stock
    cg.ChartGenerator(Ticker, StockDF, EMAperiod, TRIXperiod, TRIXSignalperiod, RSIperiod)

if __name__ == "__main__":
    main()