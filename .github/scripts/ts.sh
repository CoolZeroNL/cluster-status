#!/bin/bash
#           _____ Prelims
set -u
#   ^ unbound (i.e. unassigned) variables shall be errors.
set -e
#   ^ error checking :: Highly Recommended (caveat:  you can't check $? later).  
#
# _______________     ::  BEGIN  Script ::::::::::::::::::::::::::::::::::::::::

_host=${1:-'http://www.google.com'}
_port=${2:-'10011'}

while read line
do
    if [ "$line" == 'exit' ]; then
        echo "Received 'exit'"
        break
    else
        echo "$line"
    fi
done < <((echo -e "use \nquit") | nc -q -1 "$_host" "$_port")

if [ -z "$line" ]
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

#   echo -e "use \nquit" | \
#   nc $_host $_port | tr -d "\r" | {
#     while read -r line; do
#       echo "$line"
#     done
#   } || return 1
# exit 0
