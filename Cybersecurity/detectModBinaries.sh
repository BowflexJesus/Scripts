#!/bin/bash

# author: Matthew Darby
# date modified: 4/24/2019

# Motivation:
# Modified system binaries such as ‘login’, ‘telnet’, ‘ftp’, ‘finger’ or more
# complex daemons, ‘sshd’, ‘ftpd’ and the like. After breaking into a system, a
# hacker usually attempts to secure access by planting a backdoor in one of the
# daemons with direct access from the Internet, or by modifying standard system
# utilities which are used to connect to other systems. The modified binaries
# are usually part of a rootkit and generally, are ‘stealthed’ against direct
# simple inspection. In all cases, it is a good idea to maintain a database of
# checksums for every system utility and periodically verify them with the
# system offline, in single user mode.

MD=()

for file in $@
do
    MD+=($(md5sum $file | cut -d ' ' -f1))
    sleep 10
done


while [[ true ]];
do
    let i=0
    for file in "$@"
    do
        MD2=$(md5sum $file | cut -d ' ' -f1)
        sleep 10

        if [ ${MD[i]} != $MD2 ]
        then
            echo "ERROR: $file has been modified!"
        fi
        
        let i+=1
    done
done
