#!/bin/#!/bin/sh

while [ true ];
do
    for i in `seq 65535`
    do
        if [ $i != 22]
        then
            sockstat -l | awk 'FNR > 1 {print $2}'
        fi
    done
done
