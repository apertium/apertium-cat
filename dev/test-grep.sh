#!/bin/bash

#set -e
#set -o pipefail
echo "Grep tests"
{
for file in ../apertium-cat.cat.dix
do 
    grep -H "<i> " $file
    grep -H " </i>" $file
    grep -H "<l> " $file
    grep -H " </l>" $file
    grep -H "<r> " $file
    grep -H " </r>" $file
    grep -H -P "\xa0" $file # non-breaking space
    grep -H "<b/><s" $file
    grep -H "<b/><b/>" $file
    grep -H "<b/><g>" $file

    #Poden ser correctes
    grep -H "<b/></l>" $file | sed -E '/n="(~|cont)/d'
    grep -H "<b/></r>" $file | sed -E '/n="(~|cont)/d'
    grep -H "<b/></i>" $file | sed -E '/n="(~|cont|romana|.*el_qual__rel|.*el_seu__rel)/d' 
    
done
} > "greptests.txt"

echo "Checking for differences"
git diff --exit-code
