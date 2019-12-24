#!/bin/bash

_host=${1:-'http://www.google.com'}
_port=${2:-'25565'}

req=`curl -sq "$_host":"$_port"`

data=`echo "{"${req#*{} | grep 'disconnect.genericReason'`
echo $data

if [ -z "$data" ]
then
      echo "$_host is down"
        #down
        exit 1
else
      echo "$_host is up"
        # up
        exit 0
fi
exit 0
