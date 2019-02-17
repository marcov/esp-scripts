#!/usr/bin/env bash

set -euo pipefail

declare -r htmlFormFieldName="update"
declare boardName="d1mini"
declare confirm="1"
declare -r myName="$(basename $0)"

usage() {
	cat << EOF
Usage:
$myName [OPTIONS] ESP-HOST [ENV]

OPTIONS  -h show this help and exit
         -n do not ask for confirmation before flash

ESP-HOST IP/hostname of the ESP

ENV      name of the board specified as "env=" in platform.ini. Defaults to "${boardName}"

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
[ "$#" -ge "1" ] && boardName="$1"

binaryPath=.pioenvs/${boardName}/firmware.bin

if ! [ -f "$binaryPath" ]; then
	echo "ERR: firmware file $binaryPath does not exist"
	exit -1
fi

cat <<EOF
OTA update with the following config:
	IP     $espHost
	BOARD  $boardName

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
     -F "${htmlFormFieldName}=@${binaryPath}" \
     "${updateUrl}")

echo "Executing ${otaCmd[@]} ..."

${otaCmd[@]}
exit $?
