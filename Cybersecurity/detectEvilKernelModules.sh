#!/bin/bash

# author: Matthew Darby
# date modified: 4/24/2019

# /proc/modules file shows kernel modules currently loaded into memory

MODULES=($(lsmod | awk 'FNR > 1 {print $1}'))
OGUSED=($(lsmod | awk 'FNR > 1 {print $3}'))
while [[ true ]];
do
    let index=0
    NEWUSED=($(lsmod | awk 'FNR > 1 {print $3}'))
    for mod in $(cut -d ' ' -f 1 /proc/modules)
    do
        if [[ $mod != ${MODULES[index]} ]]
        then
            modprobe -r $mod
            echo "New module $mod detected and removed!"
        fi

        if [ ${NEWUSED[index]} -gt ${OGUSED[index]} ]
        then
            printf "%s has been modified! Originally used by %d
            modules, now being used by %d modules.\n" $mod ${OGUSED[index]} ${NEWUSED[index]}
        fi
        let index=index+1
    done
done
