#!/bin/sh
while ! ping -c1 $1 &>/dev/null
        do echo "Ping Fail for host :"$1"  - `date`"
done
printf "Host: %s\t$1\t%s`date`\n"