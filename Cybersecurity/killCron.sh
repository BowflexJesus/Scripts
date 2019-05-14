#!/bin/bash

# author: Matthew Darby
# date modified: 4/9/2019

#######################Find and kill all cron jobs##########################
# loop through all users and delete any cron jobs you find
while [[ true ]];
do
    for user in $(cut -f1 -d: /etc/passwd)
    do
        crontab -r
    done
done
############################################################################
