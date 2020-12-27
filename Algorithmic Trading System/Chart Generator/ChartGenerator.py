########################################################################################################################
# Name: Chart Generator
# Author: Cindy S Cheung
# Description: This script is the Chart Generator.  After receiving the stock ticker and its financial data for the last
#              year, generate the candlestick chart for the stock, including volume and technical indicators: EMA, TRIX,
#              and RSI (MACD has also been implemented in the code  but is not being used).
########################################################################################################################

########################################################################################################################
# Import required packages and modules
########################################################################################################################

import plotly.graph_objects as go
import plotly.io as pio
import pandas as pd
import EMA as ema
import MACD as macd
import TRIX as trix
import RSI as rsi

# Open chart in a new tab of the deafault web browser
pio.renderers.default = "browser"

########################################################################################################################
########################################################################################################################
# # Run Chart Generator
########################################################################################################################
########################################################################################################################

def ChartGenerator(Ticker, StockDF, EMAperiod, TRIXperiod, TRIXSignalperiod, RSIperiod):

    ####################################################################################################################
    # Design Layout
    ####################################################################################################################

    # Set layout paramenters
    layout = go.Layout({
        'title': {
            'text': Ticker,
            'font': {
                'size': 15
            }
        },
        'legend': {
            'orientation': 'h',
            'x': 0.3,
            'y': 0.94,
            'yanchor': 'bottom'
        },
        'margin': {
            't': 25,
            'b': 10,
            'r': 20,
            'l': 20
        },
        'plot_bgcolor': 'rgb(0, 0, 0)',
        'xaxis': {
            'showline': False,
            'showgrid': False
        },
        'yaxis': {
            'showline': False,
            'showgrid': False,
            'domain': [0, 0.1],
            'showticklabels': False
        },
        'yaxis2': {
            'showline': False,
            'showgrid': False,
            'zeroline': True,
            'zerolinecolor': '#2D54B5',
            'zerolinewidth': 1,
            'domain': [0.101, 0.22]
        },
        'yaxis3': {
            'showline': False,
            'showgrid': False,
            'zeroline': True,
            'zerolinecolor': '#2D54B5',
            'zerolinewidth': 1,
            'domain': [0.221, 0.34]
        },
        'yaxis4': {
            'showline': False,
            'showgrid': False,
            'domain': [0.345, 0.92]
        }
    })

    # Implement layout
    fig = go.Figure(layout=layout)

    ####################################################################################################################
    # Dssign Range Selector Buttons and Range Slider
    ####################################################################################################################

    # Set parameters for range selector
    rangeselector = {
        'visible': True,
        'rangeselector_x': 0.05,
        'rangeselector_y': 0.95,
        'rangeselector_bgcolor': 'rgba(255, 209, 0, 0.4)',
        'rangeselector_font': {
            'size': 13
        },
        'rangeselector_buttons': [
            {
                'count': 1,
                'label': 'Reset',
                'step': 'all'
            },
            {
                'count': 1,
                'label': '1 Year',
                'step': 'year',
                'stepmode': 'backward'
            },
            {
                'count': 3,
                'label': '3 Months',
                'step': 'month',
                'stepmode': 'backward'
            },
            {
                'count': 1,
                'label': '1 Month',
                'step': 'month',
                'stepmode': 'backward'
            },
            {
                'label': 'Max',
                'step': 'all'
            }
        ]
    }

    # Set parameters for range slider
    rangeslider = {
        'visible': True,
        'thickness': 0.02
    }

    # Implement range selector and range slider
    fig.update_layout(xaxis=go.layout.XAxis(rangeselector, rangeslider=rangeslider, showgrid=True, gridcolor='#2D54B5'))

    ####################################################################################################################
    # Draw Price Candlesticks
    ####################################################################################################################

    # Set default candlestick colors
    INCREASING_COLOR = '#1CAD07'
    DECREASING_COLOR = '#D90000'

    # Set trace parameters for price candlesticks
    Price = {
        'x': StockDF.index,
        'open': StockDF.Open,
        'close': StockDF.AdjClose,
        'high': StockDF.High,
        'low': StockDF.Low,
        'type': 'candlestick',
        'yaxis': 'y4',
        'name': Ticker,
        'showlegend': True,
        'increasing': {
            'line': {
                'color': INCREASING_COLOR
            }
        },
        'decreasing': {
            'line': {
                'color': DECREASING_COLOR
            }
        },
    }

    # Implement price candlestocks to chart
    fig.add_trace(trace = Price)


    ####################################################################################################################
    # Implement Volume
    ####################################################################################################################

    # Collect the color of each volume bar
    VolumeColor = []

    # Compute volume bar colors
    for i in range(len(StockDF.AdjClose)):
        if i != 0:
            if StockDF.AdjClose[i] > StockDF.AdjClose[i - 1]:
                VolumeColor.append(INCREASING_COLOR)
            else:
                VolumeColor.append(DECREASING_COLOR)
        else:
            VolumeColor.append(DECREASING_COLOR)

    # Set volume parameters
    VolumeBars = {
        'x': StockDF.index,
        'y': StockDF.Volume,
        'marker': {
            'color': VolumeColor
        },
        'type': 'bar',
        'yaxis': 'y',
        'name': 'Volume'
    }

    # Implement volume bars to chart
    fig.add_trace(trace = VolumeBars)

    ####################################################################################################################
    # Implement EMA
    ####################################################################################################################

    # Calculate EMA
    ExpMA = ema.ExponentialMA(StockDF.AdjClose, EMAperiod)

    # Add EMA data to stock dataframe
    StockDF = StockDF.assign(EMA=pd.Series(ExpMA, index=StockDF.index))

    # Set parameters for EMA
    traceEMA = {
        'x': StockDF.index,
        'y': StockDF.EMA,
        'type': 'scatter',
        'mode': 'lines',
        'line': {
            'width': 1
        },
        'marker': {
            'color': '#03F8FC',
        },
        'yaxis': 'y4',
        'name': 'EMA'
    }

    # Implement EMA to chart
    fig.add_trace(trace=traceEMA)

    # ####################################################################################################################
    # # Implement MACD
    # ####################################################################################################################
    #
    # # Calculate MACD
    # MAcd, MAcdsignal, MAcdhist = macd.MACD(StockDF.AdjClose)
    #
    # # Add MACD, MACD Signal, and MACD Histogram data to stock dataframe
    # StockDF = StockDF.assign(MACD=pd.Series(MAcd, index=StockDF.index))
    # StockDF = StockDF.assign(MACDSignal=pd.Series(MAcdsignal, index=StockDF.index))
    # StockDF = StockDF.assign(MACDHist=pd.Series(MAcdhist, index=StockDF.index))
    #
    # # Set parameters for MACD
    # traceMACD = {
    #     'x': StockDF.index,
    #     'y': StockDF.MACD,
    #     'type': 'scatter',
    #     'mode': 'lines',
    #     'line': {
    #         'width': 2
    #     },
    #     'marker': {
    #         'color': '#FFCC80',
    #     },
    #     'yaxis': 'y3',
    #     'name': 'MACD'
    # }
    #
    # # Set parameters for MACD Signal
    # traceMACDSignal = {
    #     'x': StockDF.index,
    #     'y': StockDF.MACDSignal,
    #     'type': 'scatter',
    #     'mode': 'lines',
    #     'line': {
    #         'width': 1.5
    #     },
    #     'marker': {
    #         'color': '#D90000',
    #     },
    #     'yaxis': 'y3',
    #     'name': 'MACD Signal'
    # }
    #
    # # Set parameters for MACD Histogram
    # traceMACDHist = {
    #     'x': StockDF.index,
    #     'y': StockDF.MACDHist,
    #     'type': 'bar',
    #     'marker': {
    #         'color': '#D90000',
    #     },
    #     'yaxis': 'y3',
    #     'name': 'MACD Histogram'
    # }
    #
    # # Implement MACD, MACD Signal, and MACD Histogram
    # fig.add_trace(trace=traceMACD)
    # fig.add_trace(trace=traceMACDSignal)
    # fig.add_trace(trace=traceMACDHist)
    #
    ####################################################################################################################
    # Implement TRIX
    ####################################################################################################################

    # Calculate TRIX
    TriXMA, TrixSignal = trix.TRIX(StockDF.AdjClose, TRIXperiod, TRIXSignalperiod)

    # Add TRIX data to stock dataframe
    StockDF = StockDF.assign(TRIX=pd.Series(TriXMA, index=StockDF.index))
    StockDF = StockDF.assign(TRIXSignal=pd.Series(TrixSignal, index=StockDF.index))

    # Set parameters for TRIX
    traceTRIX = {
        'x': StockDF.index,
        'y': StockDF.TRIX,
        'type': 'scatter',
        'mode': 'lines',
        'line': {
            'width': 2
        },
        'marker': {
            'color': '#FFCC80',
        },
        'yaxis': 'y2',
        'name': 'TRIX'
    }

    # Set parameters for TRIX Signal
    traceSignal = {
        'x': StockDF.index,
        'y': StockDF.TRIXSignal,
        'type': 'scatter',
        'mode': 'lines',
        'line': {
            'width': 1.5
        },
        'marker': {
            'color': '#D90000',
        },
        'yaxis': 'y2',
        'name': 'Signal'
    }

    # Implement TRIX and TRIX Signal
    fig.add_trace(trace = traceTRIX)
    fig.add_trace(trace=traceSignal)

    ####################################################################################################################
    # Implement RSI
    ####################################################################################################################

    # Calculate RSI
    RSi = rsi.RSI(StockDF.AdjClose, RSIperiod)

    # Add RSI data to stock dataframe
    StockDF = StockDF.assign(RSI=pd.Series(RSi, index=StockDF.index))

    # Set parameters for RSI
    traceRSI = {
        'x': StockDF.index,
        'y': StockDF.RSI,
        'type': 'scatter',
        'mode': 'lines',
        'line': {
            'width': 1.5
        },
        'marker': {
            'color': '#FF8080',
        },
        'yaxis': 'y3',
        'name': 'RSI'
    }

    # Draw lower RSI line
    fig.add_shape(type="line",
                  x0 = StockDF.index[0], x1 = StockDF.index[-1],
                  y0 = 30, y1 = 30,
                  line=dict(color='#9E4C00', width=1.5))

    # Draw lower RSI line
    fig.add_shape(type="line",
                  x0=StockDF.index[0], x1=StockDF.index[-1],
                  y0=70, y1=70,
                  line=dict(color='#9E4C00', width=1.5))

    # Reference to appropriate x-axis and y-axis
    fig.update_shapes(dict(xref='x', yref='y3'))

    # Implement RSI
    fig.add_trace(trace=traceRSI)

    ####################################################################################################################
    # Implement Spikelines
    ####################################################################################################################

    # Draw horizontal and vertical spikelines that follow mouse coordinates
    fig.update_xaxes(showspikes=True, spikecolor='#FB75FF', spikedash='solid',
                     spikesnap='cursor', spikemode='across', spikethickness=1)
    fig.update_yaxes(showspikes = True, spikecolor = '#FB75FF', spikedash = 'solid',
                     spikesnap = 'cursor', spikemode = 'across', spikethickness = 1)
    fig.update_layout(spikedistance = 1000, hoverdistance = 100)

    # Generate chart on web browser
    fig.write_html('Stock Chart.html', auto_open=True)