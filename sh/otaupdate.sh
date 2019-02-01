#!/usr/bin/env bash

echo ""

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: basename $0 env [ipaddress]"
    exit -1
fi



if [ $# -lt 1 ]; then
    env="d1mini"
else
    env="$1"
fi 

if [ $# -lt 2 ]; then
    ipaddress="cancel.lan"
    confirm=true
else
    ipaddress="$2"
    confirm=false
fi


echo "Using env=$env and ipaddress=$ipaddress"

if $confirm; then
    echo -n "Enter to confirm, everything else to abort: "
    read readVal
    if [ "$readVal" != "" ]; then
        echo "Aborted, exiting"
        exit -1
    fi
fi

echo ""

updateUrl="${ipaddress}/update"
binaryPath=.pioenvs/${env}/firmware.bin
htmlFormFieldName="update"

otaCmd=(curl \
     -F "${htmlFormFieldName}=@${binaryPath}" \
     ${updateUrl})

echo "Executing ${otaCmd[@]} ..."

${otaCmd[@]}

