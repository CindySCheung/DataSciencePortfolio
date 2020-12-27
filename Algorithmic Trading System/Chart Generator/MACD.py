########################################################################################################################
# Name: MACD Moving Average Convergence Divergence
# Author: Cindy S Cheung
# Description: This script contains the MACD function which computes the MACD Moving Average Convergence Divergence.
########################################################################################################################

########################################################################################################################
# Define MACD Function
########################################################################################################################

def MACD(adjclose):
    # Properties for Fast EMA
    NUMPERIODfast = 12
    Kfast = 2 / (NUMPERIODfast + 1)  # Smoothing factor
    EMAfast = 0  # Fast EMA list value

    # Properties for Slow EMA
    NUMPERIODslow = 26
    Kslow = 2 / (NUMPERIODslow + 1)  # Smoothing factor
    EMAslow = 0  # Slow EMA list value

    # Properties for MACD Signal
    NUMPERIODsignal = 20
    Ksignal = 2 / (NUMPERIODsignal + 1)  # Smoothing factor
    MACDsignal = 0  # Signal list value

    # Hold EMA values
    EMAfastValues = []
    EMAslowValues = []
    MACDValues = []

    # Hold MACD Signal/EMA values
    MACDSignalValues = []

    # Hold MACD Histogram values
    MACDHistogramValues = []

    # For each closing price, calculate the MACD and MACD Signal values for each date
    for ClosePrice in adjclose:

        # Set first observations to closing price of first date.  For subsequent dates, calculate the EMA values for
        # each date.
        if (EMAfast == 0):
            EMAfast = ClosePrice
            EMAslow = ClosePrice
        else:
            EMAfast = (ClosePrice - EMAfast) * Kfast + EMAfast
            EMAslow = (ClosePrice - EMAslow) * Kslow + EMAslow

        # Add EMA values to corresponding list
        EMAfastValues.append(EMAfast)
        EMAslowValues.append(EMAslow)

        # Calculate MACD
        MACD = EMAfast - EMAslow

        # Calculate MACD Signal values
        if (MACDsignal == 0):
            MACDsignal = MACD
        else:
            # Signal is EMA of MACD
            MACDsignal = (MACD - MACDsignal) * Ksignal + MACDsignal

        # Add MACD, MACD Signal, and MACD Histogram values to their respective lists
        MACDValues.append(MACD)
        MACDSignalValues.append(MACDsignal)
        MACDHistogramValues.append(MACD - MACDsignal)

    # Return MACD, MACD Signal, and MACD Histogram lists
    return MACDValues, MACDSignalValues, MACDHistogramValues