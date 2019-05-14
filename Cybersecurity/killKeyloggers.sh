#!/bin/bash

# author: Matthew Darby
# date modified: 4/9/2019

while [[ true ]];
do
    #######################Find and kill keyloggers#############################
	# use top to grab all processes matching the most known keyloggers in linux
	# [lkl, uberkey, THC-vlogger, PyKeylogger, logkeys] = most known keyloggers for linux systems
	PROCESS=$(top -b -n 1 | awk '{print $12}' | grep -wi 'lkl\|uberkey\|THC-vlogger\|PyKeylogger\|logkeys')
	echo $PROCESS
	# check if the length of $PROCESS is greater than 0
	if [[ -n $PROCESS ]]
	then
		killall -s 9 $PROCESS # kill the keylogger
		# echo -e '\a'
	fi
    ############################################################################
done
