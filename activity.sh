#!/bin/bash

 #
 # file:  activity.sh
 # author:  Matthew Darby
 # course: CSI 3336
 # assignment: Project 3
 # due date:  02/09/2018
 #
 # date modified:  02/04/2018
 #      - file created
 #
 # date modified:  02/07/2018
 #      - if statements added
 #
 # date modified:  02/08/2018
 #      - loops added, script tested, comments and header added
 #
 # This document is a script that returns the number of modified files based
 # on various parameters, along with their sizes.
 #

#Declare and initialize variables
maxActive=0
activeSize=0
maxRecent=0
recentSize=0
maxIdle=0
idleSize=0
ACTIVE=`find -type f -mtime -1`
RECENT=`find -type f -mtime -3 -and -mtime +1`
IDLE=`find -type f -mtime +3` 

#Print the working directory
echo $PWD

#Start the loop for totaling files modified less than 
#one day ago
for dir in $ACTIVE
do 
    let maxActive++
    let activeSize+=$(stat -c %s `find`)
done

#Start the loop for totaling files modified less than three days
#and older than 1 day
for dir in $RECENT
do
    let maxRecent++
    let recentSize+=$(stat -c %s `find`)
done

#Start the loop for totaling files modified over 3 days ago
for dir in $IDLE
do
    let maxIdle++
    let idleSize+=$(stat -c %s `find`)
done

echo "active: $maxActive    ($activeSize bytes)"
echo "recent: $maxRecent    ($recentSize bytes)"
echo "idle: $maxIdle    ($idleSize bytes)"
