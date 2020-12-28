########################################################################################################################
# Name: TRIX Triple Exponential Moving Average
# Author: Cindy S Cheung
# Description: This script contains the TRIX function which computes the TRIX Triple Exponential Moving Average.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

import pandas as pd
from EMA import ExponentialMA

########################################################################################################################
# Define TRIX Function
########################################################################################################################

def TRIX(adjclose, TRIXperiod, TRIXSignalperiod):

    # Set periods
#    PERIOD = TRIXperiod
#    SIGNALPERIOD = TRIXSignalperiod

    # Calculate TRIX and Signal
    EMA1 = ExponentialMA(adjclose, TRIXperiod)
    EMA1 = [round(iEMA1, 4) for iEMA1 in EMA1]
    EMA2 = ExponentialMA(EMA1, TRIXperiod)
    EMA2 = [round(iEMA2, 4) for iEMA2 in EMA2]
    EMA3 = ExponentialMA(EMA2, TRIXperiod)
    EMA3 = [round(iEMA3, 4) for iEMA3 in EMA3]
    EMA3 = pd.Series(EMA3)
    TRIX = pd.Series.to_numpy(EMA3.pct_change() * 100)

    # Set first value of TRIX to its first calculated value (eliminate NaN)
    TRIX[0] = TRIX[1]

    # Calculate TRIX Signal
    SIGNAL = ExponentialMA(TRIX, TRIXSignalperiod)

    # Return TRIX and TRIX Signal list
    return TRIX, SIGNAL