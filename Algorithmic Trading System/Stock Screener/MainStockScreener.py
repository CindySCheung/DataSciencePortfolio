########################################################################################################################
# Name: Main Stock Screener
# Author: Cindy S Cheung
# Description: This script is the encompassing stock screening program that includes all functions and parts involved
#              in the process.  It imports the User Interface file, Polaris file, Minervini file, and Expert to Excel
#              file as a bundle.  Program can be executed from beginning to end in one single file.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

from UserInterface import UserInterface
from Polaris2 import Polaris
from Minervini2 import Minervini
from DFtoExcelExporter import ExcelExporter

########################################################################################################################
# Execute Program
########################################################################################################################

def main():
    # Execute the user interface and return all user inputs to be used for the rest of the program
    MINPrice, MAXPrice, MINVolume, ScreenerType, ResultsFilename = UserInterface()

    # Select the type of screener to use based on user input
    if ScreenerType in ['P', 'p']:
        print("Running Polaris Stock Screener")
        ResultsDF = Polaris(MINPrice, MAXPrice, MINVolume)
    elif ScreenerType in ['M', 'm']:
        print("Running Minervini Stock Screener")
        ResultsDF = Minervini(MINPrice, MAXPrice, MINVolume)

    # Export final results dataframe of stocks to Excel
    ExcelExporter(ResultsDF, ResultsFilename, 1)

if __name__ == "__main__":
    main()
