#!/bin/bash

# A script that generates random integers for testing

# If parameter list is empty, print 20 random numbers between 0-999999
if [[ $# -eq 0 ]]
then
    i=0
    while [ $i -lt 20 ]
    do
        echo $(($RANDOM%999999))
        let i++
    done
fi

# If one parameter is given, print the number of values requested
if [[ $# -eq 1 ]]
then
    i=$1
    while [ $i -gt 0 ]
    do
        echo $(($RANDOM%999999))
        let i--
    done
fi

# Lastly, if 3 parameters are given, print the number of values asked for in
# parameter 1 between the range specified between parameters 2 and 3
if [[ $# -eq 3 ]]
then
    i=$1
    floor=$2
    ceiling=$3
    if [[ $floor -lt 0 || $ceiling -gt 999999 ]]
    then
        echo "ERROR: Range must be between 0-999999" 1>&2
    else
        while [ $i -gt 0 ]
        do
            echo $(($floor + $RANDOM % (1 + ceiling - floor)))
            let i--
        done
    fi
fi
