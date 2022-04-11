#!/bin/bash

# This script looks for duplicate entries,
# which may cause double generation errors.
# Path to monolingual dix/metadix is autodetected.
# Metadix requires compilation before running.

SRCDIR=$(cd ../.. && pwd)
LANG1=$(grep -m1 "^LANG1 =" $SRCDIR/Makefile | sed "s/^.*= //")

MONODIX="$SRCDIR/apertium-$LANG1.$LANG1.dix"
if ! [[ -e $MONODIX ]]; then
    MONODIX="$SRCDIR/.deps/apertium-$LANG1.$LANG1.dix"
    if ! [[ -e $MONODIX ]]; then
        echo "Monolingual dictionary ($MONODIX) not found."
        exit 1
    fi
fi

lt-expand $MONODIX | grep -v 'REGEX' | grep -v ':>:' |
rev | sed -E 's/:<:|:/\t/'| rev |
sort -t$'\t' -bk 2 |
sed -E 's/(<[^ ]*>)([^\t]*\t.*)/\1\2\t\1/' |
uniq -f 1 -D |
awk -F $'\t' '{print $2 "   --------->   " $1}' > duplicates.$LANG1.txt

exit 0
