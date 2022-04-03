#!/usr/bin/env python3

import termcolor
import colorama
import os
import sys
import math
import datetime
import pyfiglet
import time

font="contrast"
# font="doom"
# font="starwars"

def countdown(t):
    while t:
        mins, secs = divmod(t, 60)
        timer = '{:02d}:{:02d}'.format(mins, secs) 
        formatPrint(timer, font=font)
        time.sleep(1)
        t -= 1

def formatPrint(textData, font):
    colorama.init()
    colors = []

    colors = ['red', 'yellow', 'green', 'cyan', 'blue', 'magenta']
    figletTextData = pyfiglet.figlet_format(textData, font=font)

    colorsCounter = 0
    for char in figletTextData:
        if colorsCounter == len(colors):
            colorsCounter = 0

        print(termcolor.colored(char, colors[colorsCounter]), end="")
        colorsCounter+=1

def main():
    if ( (len(sys.argv) < 2 ) or (len(sys.argv) > 2)):
        print("usage:", sys.argv[0], "<time in second>")
    else:
        whatTime = int(sys.argv[1])
        countdown(whatTime)

if __name__ == '__main__':
    main()
