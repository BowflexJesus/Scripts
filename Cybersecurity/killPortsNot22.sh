#!/bin/bash

# author: Matthew Darby
# date modified: 4/9/2019

#########################Repeatedly kill all !port 22###########################
while [[ true ]];
do
     MAXPORT=65535
     for (( i=1; i<=MAXPORT; i++ ))
     do
         if [[ $i != 22 ]]
         then
             kill $(sudo lsof -t -i:$i)
         fi
     done
 done
################################################################################


 # PORTS=$(netstat -tulpn | awk 'FNR > 2 {print $4}' | sed 's/.*://')
 #
 # for port in $PORTS
 # do
    #  if [[ $port != 22 ]]
    #  then
    # 	 piTCP=$(lsof -i tcp:$port | awk 'NR!=1 {print $2}')
    # 	 kill -15 -$pidTCP
    # 	 pidUDP=$(lsof -i udp:$port | awk 'NR!=1 {print $2}')
    # 	 kill -15 -$pidUDP
    # 	 #lsof -i udp:$port | awk 'NR!=1 {print $2}' | xargs kill
    #  fi
 # done
