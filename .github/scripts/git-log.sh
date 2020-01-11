#!/bin/bash

# get all commits by: MinecraftAutoUpdater, of file: settings.cfg
git log --author-date-order --author='MinecraftAutoUpdater' -p settings.cfg > list

declare -A pararray
counter=0
tmpfile='/tmp/test.dat.tmp'
file='/tmp/test.dat'

echo '##date time         slot_1' > $tmpfile

while read line; do
    if [[ "$line" =~ ^FORGEURL ]]; then
     pararray[$counter]+="$line\n"
     ((counter=counter+1))
    else
     #no match
     pararray[$counter]+="$line\n"
    fi
done <list

echo ""
echo "=="
echo ""

for i in "${pararray[@]}"
do
        # Jan 5 00:02:49 2020 25
        echo -e "$i" | grep Date
        echo -e "$i" | grep +FORGEVER

        VER=`echo -e "$i" | grep +FORGEVER | awk -F'=' '{print $2}' | awk -F'.' '{print $3}'`
        DAT=`echo -e "$i" | grep Date | awk -F" " '{print $3 " " $4 " " $5 " " $6}'`

        echo $DAT $VER >> $tmpfile
        echo "------------------------"
done

cat $tmpfile | sort > $file
rm $tmpfile

ls -la
chmod +x ./gnuplot.pg
./gnuplot.pg

cat $file

rm $file
