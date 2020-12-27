########################################################################################################################
# Name: Minervini Stock Screener
# Author: Cindy S Cheung
# Resource: https://gist.github.com/shashankvemuri/50ed514a0ed41599ac29cc297efc3c05#file-screener-py
# Description: This script runs stocks in the S&P 500, Dow Jones, or Nasdaq through Mark Minervini's stock screening
#              criteria (except for RS Rating).  It will also include price and volume requirements.  Stocks that pass
#              the evaluation will be added to an Excel spreadsheet.  The Excel spreadsheet includes these data values
#              of each stock: Ticker, Last Closing Price, 50-Day SMA, 150-Day SMA, 200-Day SMA, 52-Week Low, 52-Week
#              High, Volume, and 150-Day SMA on Volume.
########################################################################################################################
from pandas_datareader import data as pdr
from yahoo_fin import stock_info as si
import yfinance as yf
import pandas as pd
import datetime
import time

########################################################################################################################
########################################################################################################################
# # Run Minervini Screener
########################################################################################################################
########################################################################################################################

def Minervini(MINPrice, MAXPrice, MINVolume):

    # Override pandas_datareader's get_data_yahoo() to download data faster
    yf.pdr_override()

    # Select index and initiate stock list from SP500, Dow Jones, or Nasdaq
    stocklist = si.tickers_sp500()
    # stocklist = ['AAPL', 'WRK']
    index_name = '^GSPC'  # S&P 500: ^GSPC  Dow Jones: ^DJI   Nasdaq: ^IXIC

    # Initiate stock index variable to be incremented
    n = -1

    # Initiate and configure columns of the final dataframe for the screener to be exported into Excel
    # The dataframe includes stock tickers, the last closing price, the 50-day moving average, the 150-day moving average,
    # the 200-day moving average, the 52-week low, the 52-week high, volume, and the 150-day moving average of volume.
    # Simple moving average is used.
    exportList = pd.DataFrame(
         columns=['Date', 'Stock', "Last Close", "50-Day MA", "150-Day MA", "200-Day MA", "52-Week Low", "52-Week High",
                  "Volume", "150-Day SMA Volume"])

    ########################################################################################################################
    # For each stock in the stock list, determine if it pass Minernivi's criteria plus own criteria on price and volume
    ########################################################################################################################
    for stock in stocklist:
        n += 1

        # Set a time delay between each stock
        time.sleep(0.5)

        # Inform user which stock is being evaluated
        print("\nPulling {} with Index {}".format(stock, n))

        # Set 1-year time duration starting from 365 days ago today
        start_date = datetime.datetime.now() - datetime.timedelta(days=365)
        end_date = datetime.date.today()

        # Download stock data for set time duration
        df = pdr.get_data_yahoo(stock, start=start_date, end=end_date)

        ####################################################################################################################
        # Test data out for any errors or missing data. If all is well, implement the 50-day, 150-day, and 200-day Simple
        # Moving Averages.  Set calculations as variables.  Then process the data through a modification of Minervini's
        # criteria as well as own criteria for price and volume.  If the stock passes the evaluation, add the stock's data
        # into the final dataframe to be exported to Excel.
        ####################################################################################################################
        try:
            # Calculate and implement 50-day, 150-day, and 200-day Simple Moving Average
            sma = [50, 150, 200]
            for x in sma:
                df["SMA_" + str(x)] = round(df.iloc[:, 4].rolling(window=x).mean(), 2)
                df["SMA_Vol" + str(x)] = round(df.iloc[:, 5].rolling(window=x).mean(), 2)

            # Assign calculations and data to variables
            currentClose = df["Adj Close"][-1]
            moving_average_50 = df["SMA_50"][-1]
            moving_average_150 = df["SMA_150"][-1]
            moving_average_200 = df["SMA_200"][-1]
            low_of_52week = min(df["Adj Close"][-260:])
            high_of_52week = max(df["Adj Close"][-260:])
            currentVolume = df["Volume"][-1]
            moving_average_vol_50 = df["SMA_Vol50"][-1]
            moving_average_vol_150 = df["SMA_Vol150"][-1]
            moving_average_vol_200 = df["SMA_Vol200"][-1]

            # Find the value for the 200-day moving average dated a month earlier to determine the 200-day SMA trend in the
            # last month
            try:
                moving_average_200_20 = df["SMA_200"][-20]
            except Exception:
                moving_average_200_20 = 0

            ################################################################################################################
            # Minervini's Criteria with Modifications
            # 1. The last close price of the stock must be between $25 and $50.
            # 2. The last close price of the stock must be higher than the 50-Day SMA.
            # 3. The 50-Day SMA must be higher than the 150-Day SMA.
            # 4. The 150-Day SMA must be higher than the 200-Day SMA.
            # 5. The 200-Day SMA must be in an upward trend in the last month (Current 200-Day SMA must be higher than the
            #    200-Day SMA 20 trading days ago.
            # 6. The last closing price of the stock must be at least 30% higher than the 52-Week Low.
            # 7. The last closing price of the stock must be within 25% of the 52-Week High.
            # 8. The current volume must be at least 1 million.
            # 9. The 150-Day SMA for volume must be at least 1 million.
            #
            # Stocks that pass the evaluation are added final dataframe to be exported to Excel.
            ################################################################################################################
            if currentClose >= MINPrice and currentClose <= MAXPrice:
                if currentClose > moving_average_50 > moving_average_150 > moving_average_200:
                    if moving_average_200 > moving_average_200_20:
                        if currentClose >= (1.3 * low_of_52week):
                            if currentClose >= (.75 * high_of_52week):
                                if currentVolume >= MINVolume:
                                    if moving_average_vol_150 >= MINVolume:
                                        exportList = exportList.append({'Stock': stock, "Last Close": currentClose,
                                                                        "50-Day MA": moving_average_50,
                                                                        "150-Day MA": moving_average_150,
                                                                        "200-Day MA": moving_average_200,
                                                                        "52-Week Low": low_of_52week,
                                                                        "52-Week High": high_of_52week,
                                                                        "Volume": currentVolume,
                                                                        "150-Day SMA Volume": moving_average_vol_150},
                                                                       ignore_index=True)

                                        # Inform user that the stock passed the evaluation
                                        print(stock + " made the requirements")
                                    else:
                                        condition = False
                                else:
                                    condition = False
                            else:
                                condition = False
                        else:
                            condition = False
                    else:
                        condition = False
                else:
                    condition = False
            else:
                condition = False


        # Inform user when there is an error in stock data
        except Exception as e:
            print(e)
            print("No data on " + stock)

    # Add date to final dataframe
    exportList['Date'] = end_date

    # Display the final dataframe of stocks
    print(exportList)

    return exportList
