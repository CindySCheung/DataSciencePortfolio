########################################################################################################################
# Name: Dataframe to Excel Exporter
# Author: Cindy S Cheung
# Description: This script exports the final results dataframe of stocks to Excel.  The Excel file shall use the
#              filename inputted by the user.  If it is found that a file with the same name exists in the current
#              working directory, a version number shall be added or changed.
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

import os.path
from os import path
from pandas import ExcelWriter

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
# Check if desired filename already exists
# If not, create the Excel file with the name and export resulting stocks dataframe to it
# if so, raise the File Exists Error and increment the filename until a new one can be created
########################################################################################################################
def ExcelExporter(ResultsDF, Filename, i = 1):

    try:
        if not path.exists(Filename + "%s.xlsx" % i):

            # Add Version ID
            Filename = Filename + "%s.xlsx" % i

            # Create an Excel writer
            writer = ExcelWriter(Filename)

            # Convert exportList dataframe to Excel
            ResultsDF.to_excel(writer, "Sheet1")

            # Close the Excel writer and save Excel file to project directory
            writer.save()
            print(color.BLUE + "Results has been exported as " + Filename + " in " + os.getcwd() + color.END)

        # Raise error if file already exists in working directory
        else:
            raise FileExistsError

    # Increment filename
    except FileExistsError:
        i += 1
        ExcelExporter(ResultsDF, Filename, i)