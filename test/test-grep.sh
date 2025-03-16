#!/bin/bash

#set -e
#set -o pipefail
echo "Grep tests"
{
for file in apertium-cat.cat.metadix
do 
    grep -H -P "\xa0" $file # non-breaking space
    grep -H -P "<i>[^<]+ [^<]+</i>" $file
    grep -H -P "<l>[^<]+ [^<]+</l>" $file
    grep -H -P "<r>[^<]+ [^<]+</r>" $file
done

for file in $(mktemp)
do
    lt-expand apertium-cat.cat.metadix > $file
    grep " :" $file
    grep ": " $file
    grep " <" $file
    grep "  " $file
    grep " #" $file
    grep -P "^ " $file
    rm $file
done
}
