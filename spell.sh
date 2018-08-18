#!/bin/bash

 #
 # file:  spell.sh
 # author:  Matthew Darby
 # course: CSI 3336
 # assignment:  Homework 5
 # due date:  02/09/2018
 #
 # date modified:  02/08/2018
 #      - file created
 #
 # This document is a script that checks if the words passed to it
 # are in the dictionary.
 #

for foo in $@
do
    if grep -qi "$foo" "/usr/share/dict/words" 
    then
        echo "$foo is in the dictionary."
    else
        echo "$foo is not a word in the dictionary."
    fi    
  
done
