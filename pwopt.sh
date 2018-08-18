#!/bin/bash

 #
 # file:  pwopt.sh
 # author:  Matthew Darby
 # course: CSI 3336
 # assignment:  Homework 5
 # due date:  02/09/2018
 #
 # date modified:  02/08/2018
 #      - file created
 #
 # This document is a script that runs automates various print options.
 #

# Declare variables based on the positional parameters
param1=$1
param2=$2
param3=$3

# Print duplex
if [[ "$param1" == "-duplex" ]]
then
    lpr -o sides=two-sided-long-edge $2

# Print N-Up
elif [[ "$param1" == "-nUp" ]]
then
    lpr -o number-up=$param2 $param3

# Print 'n' number of copies
elif [[ "$param1" == "-copy" ]]
then
    lpr -"param2" $param3 
fi
