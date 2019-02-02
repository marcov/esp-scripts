#!/usr/bin/env bash

set -euo pipefail

declare -r htmlFormFieldName="update"
env="d1mini"

if [ "$#" -lt "1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	cat << EOF
Usage: $(basename $0) ESP-HOST [ENV]

ESP-HOST IP/hostname of the ESP
ENV      name of the board specified as "env=" in platform.ini. Defaults to "${env}"
EOF
	exit -1
fi

espHost="$1"
updateUrl="${espHost}/update"

shift
[ "$#" -ge "1" ] && env="$1"
binaryPath=.pioenvs/${env}/firmware.bin

if ! [ -f "$binaryPath" ]; then
	echo "ERR: firmware file $binaryPath does not exist"
	exit -1
fi

cat <<EOF
OTA update with the following config:
	IP   $espHost
	ENV  $env

EOF

echo -n "Confirm [y/N]: "
read readVal
if [ "$readVal" != "y" ]; then
	echo "Aborted, exiting"
	exit -1
fi

echo ""


otaCmd=(curl \
     -F "${htmlFormFieldName}=@${binaryPath}" \
     "${updateUrl}")

echo "Executing ${otaCmd[@]} ..."

${otaCmd[@]}
exit $?
