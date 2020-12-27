########################################################################################################################
# Name: User Interface
# Author: Cindy S Cheung
# Description: This script is the user interface for the stock screener.  It asks for user input to obtain the user's
#              desired stock price range, volume, type of screener (Polaris or Minervini), and filename of the
#              resulting stocks list.
########################################################################################################################

########################################################################################################################
# Color scheme for console text
########################################################################################################################

class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'

########################################################################################################################
########################################################################################################################
# # Run User Interface
########################################################################################################################
########################################################################################################################

def UserInterface():

    # Display welcome message
    print(color.BOLD + color.DARKCYAN + "Welcome to the Polaris-Minervini Stock Screener" + color.END)
    print("Choose between the Polaris Screener and the Minervini Screener \n with the desired price range and volume")
    print('\n')

    # Prompt user for information: minimum stock price, maximum stock price, minimum volume, type of screener (Polaris
    #   or Minervini, and desired filename.  It validates the inputs for each parameter.  If input value is not valid,
    #   it shall send an error message and ask the user for another input.
    while True:
        try:
            MINPrice = float(input(color.PURPLE + "Enter MINimum stock price (US Dollars): " + color.END))

            if MINPrice < 0:
                raise ValueError

        except ValueError:
            print("Sorry.  Value must be a positive number.")
        else:
            while True:
                try:
                    MAXPrice = float(input(color.PURPLE + "Enter MAXimum stock price (US Dollars): " + color.END))

                    if MAXPrice < 0 or MAXPrice < MINPrice:
                        raise ValueError
                except ValueError:
                    print("Sorry.  Value must be a positive number larger than MINimum stock price.")
                else:
                    while True:
                        try:
                            MINVolume = float(input(color.PURPLE + "Enter MINimum volume: " + color.END))

                            if MINVolume < 0:
                                raise ValueError
                        except ValueError:
                            print("Sorry.  Value must be a positive number.")
                        else:
                            while True:
                                try:
                                    print(color.PURPLE +
                                          "Choose between the Polaris Screener and the Minervini Screener" +
                                          color.END)

                                    ScreenerType = input(color.PURPLE +
                                                         "  (Type P/p for Polaris or M/m for Minervini): " +
                                                         color.END)

                                    if ScreenerType not in ['P', 'p', 'M', 'm']:
                                        raise ValueError
                                except ValueError:
                                    print("Sorry.  Value must be either a 'P' for Polaris or 'M' for Minervini.")
                                else:
                                    while True:
                                        try:
                                            ResultsFilename = input(color.PURPLE +
                                                                "Enter filename for screener results: " +
                                                                color.END)
                                        except ValueError:
                                            print("Sorry.  Filename is not valid.")
                                        else:
                                            break
                                    break
                            break
                    break
            break

    # Return user input values to Main Stock Screener to be used by the rest of the program
    return MINPrice, MAXPrice, MINVolume, ScreenerType, ResultsFilename