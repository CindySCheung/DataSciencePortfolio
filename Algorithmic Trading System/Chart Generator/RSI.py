########################################################################################################################
# Name: RSI Relative Strength Index
# Author: Cindy S Cheung
# Description: This script computes the RSI Relative Strength Index.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

import statistics as stats

########################################################################################################################
# Define RSI Function
########################################################################################################################

def RSI(adjclose, RSIperiod):

    # Set period
#    PERIOD = 14

    # Collect RSI-Necessary Values
    GainHistory = []  # Gain History
    LossHistory = []  # Loss History
    RSIValues = []  # RSI Values

    # CurrentPrice - LastPrice > 0 => Gain; CurrentPrice - LastPrice < 0 => Loss
    LastPrice = 0

    # For each date, calculate the gains and losses of each date
    for ClosePrice in adjclose:
        if LastPrice == 0:
            LastPrice = ClosePrice

        # Add gains and losses to their corresponding lists
        GainHistory.append(max(0, ClosePrice - LastPrice))
        LossHistory.append(max(0, LastPrice - ClosePrice))

        # Update last price to closing price (so that prices can be compared with that of the previous date
        LastPrice = ClosePrice

        # Ensure that the lengths of history lists are no longer that the period
        if len(GainHistory) > RSIperiod:
            del (GainHistory[0])
            del (LossHistory[0])

        # Calculate the average gain over period
        AvgGain = stats.mean(GainHistory)

        # Calculate the average loss over period
        AvgLoss = stats.mean(LossHistory)

        # Initialize Relative Strength variable
        RS = 0

        # Avoid division by 0 to calculate RSI
        if AvgLoss > 0:
            RS = AvgGain / AvgLoss

        # Calculate RSI
        RSI = 100 - (100 / (1 + RS))

        # Add RSI values to its list
        RSIValues.append(RSI)

    # Return RSI list
    return RSIValues

