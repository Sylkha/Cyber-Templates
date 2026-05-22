#!/bin/bash

function ctrl_c(){
        echo -e "\n\n[!] Exit...\n"
        exit 1
}

# Ctrl+C
trap ctrl_c SIGINT

declare -a ports=( $(seq 1 65535) )

function checkPort(){
        host=$1
        port=$2
        (exec 3<> /dev/tcp/$host/$port) 2>/dev/null

        # if code state is 0 (previous line), success
        if [ $? -eq 0 ]; then
                echo "[+] Host $1 - Port $2 (OPEN)"
        fi

        exec 3<&-
        exec 3>&-
}

if [ $1 ]; then
        for port in ${ports[@]}; do
          checkPort $1 $port #& creating threads, but working in a virual machine can be too much
        done
else
        echo -e "\n[!] Use: $0 <ip-address>\n"
fi
