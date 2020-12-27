########################################################################################################################
# Name: Load Financial Data
# Author: Cindy S Cheung
# Description: This script is the Financial Data Loader.  After receiving the stock ticker, it shall retrieve financial
#              data for that ticker for the last year from Yahoo Finance.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

from pandas_datareader import data as pdr
import yfinance as yf
import datetime
import time

# Override pandas_datareader's get_data_yahoo() to download data faster
yf.pdr_override()

########################################################################################################################
########################################################################################################################
# # Run Financial Data Loader
########################################################################################################################
########################################################################################################################

def LoadFinancialData(stock):
    # Set a time delay between each stock
    time.sleep(0.25)

    # Inform user which stock is being evaluated
    print("\nDownloading {}".format(stock))

    # Set 1-year time duration starting from 365 days ago today
    start_date = datetime.datetime.now() - datetime.timedelta(days = 366)
    end_date = datetime.date.today()

    # Download stock data for set time duration
    StockDF = pdr.get_data_yahoo(stock, start = start_date, end = end_date)

    # Rename the Adj Close column to remove space so that it can be process in other parts
    StockDF.rename(columns={'Adj Close': 'AdjClose'}, inplace = True)

    # Return financial data dataframe to the main terminal to be charted and analyzed
    return StockDF