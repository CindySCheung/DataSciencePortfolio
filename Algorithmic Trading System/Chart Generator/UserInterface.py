########################################################################################################################
# Name: User Interface
# Author: Cindy S Cheung
# Description: This script is the user interface for the stock screener.  It asks for user input to obtain the user's
#              desired stock price range, volume, type of screener (Polaris or Minervini), and filename of the
#              resulting stocks list.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

from yahoo_fin import stock_info as si
import TextColor as tc

########################################################################################################################
########################################################################################################################
# # Run User Interface
########################################################################################################################
########################################################################################################################

def UserInterface():

    # Display welcome message
    print(tc.color.BCYAN + "Welcome to Interactive TRIX Stock Charts" + tc.color.COLOR_OFF)
    print("Select a stock to generate stock charts with TRIX")
    print('\n')

    # Ask user to enter the ticker of the desired S&P 500 stock
    # Validate the input
    # If the input ticker is not valid, it shall send an error message and ask the user for another input.
    while True:
        try:
            Stock = input(tc.color.PURPLE + "Enter stock ticker: " + tc.color.COLOR_OFF).upper()

            if not Stock in si.tickers_sp500():
                raise ValueError
        except ValueError:
            print("Sorry.  This is not a valid stock ticker.")
        else:
            while True:
                try:
                    EMAperiod = float(input(tc.color.PURPLE + "Enter EMA Period: " + tc.color.COLOR_OFF))

                    if EMAperiod < 0:
                        raise ValueError
                except ValueError:
                    print("Sorry, EMA Period must be a positive integer.")
                else:
                    while True:
                        try:
                            TRIXperiod = float(input(tc.color.PURPLE + "Enter TRIX Period: " + tc.color.COLOR_OFF))

                            if TRIXperiod < 0:
                                raise ValueError
                        except ValueError:
                            print("Sorry, TRIX Period must be a positive integer.")
                        else:
                            while True:
                                try:
                                    TRIXSignalperiod = float(
                                        input(tc.color.PURPLE + "Enter TRIX Signal Period: " + tc.color.COLOR_OFF))

                                    if TRIXSignalperiod < 0:
                                        raise ValueError
                                except ValueError:
                                    print("Sorry, TRIX Signal Period must be a positive integer.")
                                else:
                                    while True:
                                        try:
                                            RSIperiod = float(
                                                input(
                                                    tc.color.PURPLE + "Enter RSI Period: " + tc.color.COLOR_OFF))

                                            if RSIperiod < 0:
                                                raise ValueError
                                        except ValueError:
                                            print("Sorry, RSI Period must be a positive integer.")
                                        else:
                                            break
                                    break
                            break
                    break
            break

    # Return user input values to Main Chart Generator to be used by the rest of the program
    return Stock, EMAperiod, TRIXperiod, TRIXSignalperiod, RSIperiod