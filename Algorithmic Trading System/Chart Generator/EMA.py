########################################################################################################################
# Name: EMA Exponential Moving Average
# Author: Cindy S Cheung
# Description: This script contains the ExponentialMA function which computes the EMA Exponential Moving Average.
########################################################################################################################

########################################################################################################################
# Define Exponential MA Function
########################################################################################################################

def ExponentialMA(close, period):

    # Initialize varibles
    EMAn = 0  # Individual EMA Values
    EMA = []  # Ema List

    # Smoothing Constant
    SMOOTHING = 2 / (period + 1)

    # The first EMA value shall be the closing price of the first date in the timeframe.  Afterwards, calculate the
    # EMA for each subsequent date.
    for ClosePrice in close:
        if (EMAn == 0):
            EMAn = ClosePrice
        else:
            EMAn = (SMOOTHING * (ClosePrice - EMAn)) + EMAn

        # Add the EMA value to the list
        EMA.append(EMAn)

    # Return the EMA list
    return EMA