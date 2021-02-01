#!/bin/sh
for f in *.zip
do
  echo `echo $f | sed 's/\.zip//g'`
  ./test_hosts.sh `echo $f | sed 's/\.zip//g'`
done