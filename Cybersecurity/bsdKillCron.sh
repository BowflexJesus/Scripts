#!/bin/sh

while [ true ];
do
    for user in $(cut -f1 -d: /etc/passwd)
    do
        crontab -r
    done
done
