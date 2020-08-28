#!/bin/bash

if [ $# -eq 0 ]
then
    echo -e "No arguments supplied\n"
    echo "Usage: `basename $0` <NETWORK>"
    echo "Example: `basename $0` 10.0.0.0"
    exit 0
fi

IPNETWORK="${1%.*}"

for i in `seq 1 254`
do
    echo -n "-> Checking IP ${IPNETWORK}.${i} ... "

    fping -q -c 1 -t 200 "${IPNETWORK}.${i}" 1>/dev/null 2>/dev/null

    if [ $? -eq 0 ]
    then
        arping -D -I enp11s0 -c 2 "${IPNETWORK}.${i}" 1>/dev/null 2>/dev/null

        if [ $? -eq 0 ]
        then
            echo "[DUP]"
            echo "${IPNETWORK}.${i}" >> ipdup.txt
        else
            echo "[OK]"
        fi
    else
        echo "[DOWN]"
    fi
done
