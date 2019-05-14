#!/bin/bash

# author: Matthew Darby
# date modified: 4/9/2019

#######################Find and kill all at jobs############################
while [[ true ]];
do
    ATD=$(atq | awk '{print $1}'
    for i in $ATD
    do
        atrm $i
    done
done
############################################################################
