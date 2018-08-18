#!/bin/bash

 #
 # file:  println.sh
 # author:  Matthew Darby
 # course: CSI 3336
 # assignment:  Homework 5
 # due date:  02/09/2018
 #
 # date modified:  02/08/2018
 #      - file created
 #
 # This document is a script that prints the line number from the file
 # given by the user.
 #

param1=$1
param2=$2
if [[ ! -n $param1 ]]
then
    echo Line does not exist >&2

elif [[ ! -e $param2 ]]
then
    echo File does not exist >&2
else
    sed -n $1p < $2
fi
