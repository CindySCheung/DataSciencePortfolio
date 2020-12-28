########################################################################################################################
# Name: Polaris Stock Screener
# Author: Cindy S Cheung
# Resource:  Polaris Competition
# Description:  This script runs stocks in the S&P 500, Dow Jones, or Nasdaq through criteria based on quarterly income
#               statements learned from the Polaris Competition during MBA program.  It will also include price and
#               volume requirements.  Stocks that pass the evaluation will be added to an Excel spreadsheet.  The Excel
#               spreadsheet includes these data values of each stock: Ticker, Last Closing Price, slope of the Best Fit
#               Line for Gross Profit Margin, slope for the Best Fit Line for Operations Margin, Gross Profit for last
#               four quarters, Operations Income for last four quarters, Total Revenue for the last four quarters, Gross
#               Profit Margin for last four quarters, and Operations Margin for last four quarters.
# Criteria: For any particular stock, both Operations Margin and Gross Profit Margin must be in an increasing trend over
#           the last four (4) quarters (ideally eight (8)).  In addition, Operations Margin must increase faster than
#           Gross Profit Margin.
#
# NOTE: Currently, this script only runs screener for S&P 500 stocks.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

from pandas_datareader import data as pdr
from yahoo_fin import stock_info as si
import yfinance as yf
import pandas as pd
import numpy as np
import datetime
import time

########################################################################################################################
########################################################################################################################
# # Run Polaris Screener
########################################################################################################################
########################################################################################################################

def Polaris(MINPrice, MAXPrice, MINVolume):
    # Override pandas_datareader's get_data_yahoo() to download data faster
    yf.pdr_override()

    # Widen the console to display more columns
    pd.options.display.width = 0

    # Select index and initiate stock list from SP500, Dow Jones, or Nasdaq
    stocklist = si.tickers_sp500()
    # stocklist = ['AAPL', 'WRK']
    # index_name = '^GSPC'  # S&P 500: ^GSPC  Dow Jones: ^DJI   Nasdaq: ^IXIC

    # Initiate stock index variable to be incremented
    n = -1

    # Initiate income statement dataframe for downloaded income statements
    # income_statement = pd.DataFrame()

    # Initiate dictionary (array of dataframes) to collect needed fundamental data from income statement for stocks that
    # pass the evaluation
    polarisDict = {}

    # Initiate and configure columns of the final dataframe for the screener to be exported into Excel
    # The dataframe includes stock tickers, the last closing price, slope of the Best Fit Line for Gross Profit Margin,
    # slope for the Best Fit Line for Operations Margin, Gross Profit for last four quarters, Operations Income for last
    # four quarters, Total Revenue for the last four quarters, Gross Profit Margin for last four quarters, and
    # Operations Margin for last four quarters.
    # Simple moving average is used.
    exportList = pd.DataFrame(
        columns=['Date', 'Stock', "Last Close", "GPM Best Fit Slope", "Ops Margin Best Fit Slope", "Volume",
                 "150-Day SMA Volume", "Gross Profit Q1", "Gross Profit Q2", "Gross Profit Q3", "Gross Profit Q4",
                 "Operations Income Q1", "Operations Income Q2", "Operations Income Q3", "Operations Income Q4",
                 "Total Revenue Q1", "Total Revenue Q2", "Total Revenue Q3", "Total Revenue Q4",
                 "Gross Profit Margin Q1", "Gross Profit Margin Q2", "Gross Profit Margin Q3", "Gross Profit Margin Q4",
                 "Operations Margin Q1", "Operations Margin Q2", "Operations Margin Q3", "Operations Margin Q4"])

    ####################################################################################################################
    # For each stock in the stock list, determine if it pass the Polaris criteria plus own criteria on price and volume
    ####################################################################################################################
    for stock in stocklist:
        n += 1

        # Set a time delay between each stock
        time.sleep(0.25)

        # Inform user which stock is being evaluated
        print("\nPulling {} with Index {}".format(stock, n))

        # Set 1-year time duration starting from 365 days ago today
        start_date = datetime.datetime.now() - datetime.timedelta(days=365)
        end_date = datetime.date.today()

        # Download stock data for set time duration
        df = pdr.get_data_yahoo(stock, start=start_date, end=end_date)

        ################################################################################################################
        # Test data out for any errors or missing data. If all is well, implement the 150-day Simple Moving Average for
        # volume.  Set calculations as variables.  Needed income statement data is stored in a working dataframe.  The
        # data is used to create best fit trendlines for Gross Profit Margins and Operations Margins. Then process the
        # data through the Polaris criteria as well as own criteria for price and volume.  If the stock passes the
        # evaluation, add the stock's data into the final dataframe to be exported to Excel.
        ################################################################################################################
        try:
            # Calculate and implement 50-day, 150-day, and 200-day Simple Moving Average
            df["SMA_Vol150"] = round(df.iloc[:, 5].rolling(window=150).mean(), 2)

            # Assign calculations and data to variables
            currentClose = df["Adj Close"][-1]
            currentVolume = df["Volume"][-1]
            moving_average_vol_150 = df["SMA_Vol150"][-1]

            # Download income statement data for the last four quarters
            income_statement = si.get_income_statement(stock, yearly=False)

            # Extract Gross Profit, Operations Income, and Total Revenue then calculate Gross Profit Margin and
            # Operations Margin
            polarisDF = income_statement.loc[['totalRevenue', 'grossProfit', 'operatingIncome'], :]
            polarisDF.loc['grossProfitMargin'] = polarisDF.loc['grossProfit'] / polarisDF.loc['totalRevenue']
            polarisDF.loc['operationsMargin'] = polarisDF.loc['operatingIncome'] / polarisDF.loc['totalRevenue']

            # Reverses the columns to sort quarters in chronological order from earliest to latest
            polarisDF = polarisDF.iloc[:, ::-1]

            ############################################################################################################
            # Find trends for Gross Profit Margin and Operations Margin by fitting Best Fit Lines
            ############################################################################################################
            # Prepare quarter indexes up in a NumPy array to be used in np.polyfit
            Quarters = np.array([1, 2, 3, 4], dtype=int)

            # Prepare Gross Profit Margin in a NumPy array to be used in np.polyfit
            GrossProfitMargin = polarisDF.loc['grossProfitMargin', ]
            GPMValues = np.array(GrossProfitMargin, dtype=float)

            # Prepare Operations Margin in a NumPy array to be used in np.polyfit
            OperationsMargin = polarisDF.loc['operationsMargin', ]
            OpsMValues = np.array(OperationsMargin, dtype=float)

            # Calculate slope(m) and y-intercept(b) of best fit trendline for Gross Profit Margin
            GPMBestFit_m, GPMBestFit_b = np.polyfit(Quarters, GPMValues, 1)

            # Calculate slope(m) and y-intercept(b) of best fit trendline for Operations Margin
            OpsMBestFit_m, OpsMBestFit_b = np.polyfit(Quarters, OpsMValues, 1)

            ############################################################################################################
            # Polaris Criteria with Modifications
            # 1. The last close price of the stock must be between minimum desired price and maximum desired price.
            # 2. Gross Profit Margin must be trending positive.
            # 3. Operations Margin must be trending positive.
            # 4. Operations Margin must be trending positively steeper than Gross Profit Margin.
            # 5. The current volume must be at least 1 million.
            # 6. The 150-Day SMA for volume must be at least 1 million.
            #
            # Stocks that pass the evaluation are added final dataframe to be exported to Excel.
            ############################################################################################################
            if currentClose >= MINPrice and currentClose <= MAXPrice:
                if GPMBestFit_m > 0:
                    if OpsMBestFit_m > 0:
                        if OpsMBestFit_m > GPMBestFit_m:
                            if currentVolume >= MINVolume:
                                if moving_average_vol_150 >= MINVolume:
                                    polarisDict[stock] = polarisDF

                                    exportList = exportList.append({'Stock': stock, "Last Close": currentClose,
                                                                    "GPM Best Fit Slope": GPMBestFit_m,
                                                                    "Ops Margin Best Fit Slope": OpsMBestFit_m,
                                                                    "Volume": currentVolume,
                                                                    "150-Day SMA Volume": moving_average_vol_150,
                                                                    "Gross Profit Q1":
                                                                        polarisDF.loc['grossProfit'].iloc[0],
                                                                    "Gross Profit Q2":
                                                                        polarisDF.loc['grossProfit'].iloc[1],
                                                                    "Gross Profit Q3":
                                                                        polarisDF.loc['grossProfit'].iloc[2],
                                                                    "Gross Profit Q4":
                                                                        polarisDF.loc['grossProfit'].iloc[3],
                                                                    "Operations Income Q1":
                                                                        polarisDF.loc['operatingIncome'].iloc[0],
                                                                    "Operations Income Q2":
                                                                        polarisDF.loc['operatingIncome'].iloc[1],
                                                                    "Operations Income Q3":
                                                                        polarisDF.loc['operatingIncome'].iloc[2],
                                                                    "Operations Income Q4":
                                                                        polarisDF.loc['operatingIncome'].iloc[3],
                                                                    "Total Revenue Q1":
                                                                        polarisDF.loc['totalRevenue'].iloc[0],
                                                                    "Total Revenue Q2":
                                                                        polarisDF.loc['totalRevenue'].iloc[1],
                                                                    "Total Revenue Q3":
                                                                        polarisDF.loc['totalRevenue'].iloc[2],
                                                                    "Total Revenue Q4":
                                                                        polarisDF.loc['totalRevenue'].iloc[3],
                                                                    "Gross Profit Margin Q1": GrossProfitMargin[0],
                                                                    "Gross Profit Margin Q2": GrossProfitMargin[1],
                                                                    "Gross Profit Margin Q3": GrossProfitMargin[2],
                                                                    "Gross Profit Margin Q4": GrossProfitMargin[3],
                                                                    "Operations Margin Q1": OperationsMargin[0],
                                                                    "Operations Margin Q2": OperationsMargin[1],
                                                                    "Operations Margin Q3": OperationsMargin[2],
                                                                    "Operations Margin Q4": OperationsMargin[3]},
                                                                   ignore_index=True)

                                    # Inform user that the stock passed the evaluation
                                    print(stock + " made the requirements")

        # Inform user when there is an error in stock data
        except Exception as e:
            print(e)
            print("No data on " + stock)

    # Add date to final dataframe
    exportList['Date'] = end_date

    # Display the final dataframe of stocks
    print(exportList)

    return exportList