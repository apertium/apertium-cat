#!/bin/bash

set -e -u

BILINGUAL=false

show_help () {
    cat >&2 <<EOF
USAGE: $0 [ -b ] [ dix ]

 -b, --bilingual: find bilingual duplicates (check dix on both sides)
 -h, --help:      show this help

Look for duplicate entries, which may cause double generation errors.
If no path is specified, the monodix/bidix will be autodetected.
Metadix requires compilation before running.

EOF
    exit 1
}

if [ $# -gt 0 ]; then
    while :; do
        case $1 in
            -b|--bilingual)
                BILINGUAL=true
                ;;
            -h|-\?|--help)
                show_help
                ;;
            --)
                shift
                break
                ;;
            *)
                break
        esac
        shift
    done
fi

if [[ $# -eq 0 ]]; then
    DIX=guess
else
    DIX=$1
fi

SRCDIR=$(pwd)
for i in {1..3}; do
    if [[ -e $SRCDIR/modes.xml ]]; then
        break
    fi
    cd '..'
    SRCDIR=$(pwd)
done

LANG1=$(grep -m1 "^LANG1 =" $SRCDIR/Makefile | sed "s/^.*= //")
LANG2=$(grep -m1 "^LANG2 =" $SRCDIR/Makefile | sed "s/^.*= //")
if [[ "$LANG2" ]]; then
    BILINGUAL=true
fi

if [[ $DIX = "guess" ]]; then
    if $BILINGUAL; then
        DIX="$SRCDIR/apertium-$LANG1-$LANG2.$LANG1-$LANG2.dix"
        if ! [[ -e $DIX ]]; then
            DIX="$SRCDIR/.deps/apertium-$LANG1-$LANG2.$LANG1-$LANG2.dix"
            if ! [[ -e $DIX ]]; then
                echo "Bilingual dictionary ($DIX) not found."
                exit 1
            fi
        fi
    else
        DIX="$SRCDIR/apertium-$LANG1.$LANG1.dix"
        if ! [[ -e $DIX ]]; then
            DIX="$SRCDIR/.deps/apertium-$LANG1.$LANG1.dix"
            if ! [[ -e $DIX ]]; then
                echo "Monolingual dictionary ($DIX) not found."
                exit 1
            fi
        fi
    fi
fi

find_duplicates () {
    if $BILINGUAL; then
        awk -F'\t' 'a[$0]++ {print $1 " " $2 " " $3}'
    else
        # Check only generation, taking preferences into account
        grep "<--" \
        | sed -E 's/(<[^ ]*>)(([^\t<]*)(<[^ ]*>)*)(\t.*)/\1\2\5\t\1\4/' \
        | awk -F'\t' 'a[$2$3$4]++ {print $1 " " $2 " " $3}'
    fi
}

lt-expand $DIX \
| sed '/:[<>]:/b;s/\\:/§§§/g;s/:/:-:/g;s/§§§/\\:/g' \
| awk -F':[<>\\-]:' '
          $0 ~ /:-:|:>:/ {print $1 "\t-->\t" $2}
          $0 ~ /:-:|:<:/ {print $1 "\t<--\t" $2}' \
| find_duplicates

exit 0
