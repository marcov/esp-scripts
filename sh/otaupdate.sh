#!/usr/bin/env bash

set -euo pipefail

declare -r htmlFormFieldName="update"
declare fwPath=".pio/build/d1mini/firmware.bin"
declare confirm="1"
declare -r myName="$(basename $0)"

usage() {
	cat << EOF
Usage:
$myName [OPTIONS] ESP_HOST FW_PATH

OPTIONS  -h show this help and exit
         -n do not ask for confirmation before flash

ESP_HOST IP/hostname of the ESP

FW_PATH      Path to firmware.bin. Defaults to "${fwPath}"

EOF
	exit -1
}

if [ "$#" -lt "1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	usage
fi

while [ "$#" -ge "1" ]; do
	param="$1"

	case "$param" in
		-n)
			confirm=
			;;
		*)
			espHost="$param"
			break
			;;
	esac
	shift
done

[ -z "${espHost:-}" ] && { echo -e "ERROR: no ESP-HOST SPECIFIED\n"; usage; }
updateUrl="${espHost}/update"
shift
[ "$#" -ge "1" ] && fwPath="$1"

if ! [ -f "$fwPath" ]; then
	echo "ERR: firmware file $fwPath does not exist"
	exit -1
fi

cat <<EOF
OTA update with the following config:
	IP     $espHost
	FW     $fwPath

EOF

if [ -n "$confirm" ]; then
	echo -n "Confirm [y/N]: "
	read readVal
	if [ "$readVal" != "y" ]; then
		echo "Aborted, exiting"
		exit -1
	fi
fi

echo ""


otaCmd=(curl \
     -F "${htmlFormFieldName}=@${fwPath}" \
     "${updateUrl}")

echo "Executing ${otaCmd[@]} ..."

${otaCmd[@]}
exit $?
