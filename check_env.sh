#!/bin/bash
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

if [ ! "${EUID}" -eq 0 ] ; then
	echo "Error: Pleas do run root!"
	exit 1
fi

function usage_exit()
{
	echo "Usage: $0 [-h|-d] ..." 1>&2
	exit 1
}

# @param : Err Message
function abort_exit()
{
	local status=$?
	echo "$@" 1>&2
	echi 1
}

while getopts hd OPT
do
	case $OPT in
		h) usage_exit
		;;
		d) set -ex
		;;
		\?) usage_exit
		;;
	esac
done

PACKAGE_LIST=( docker \
       	       docker-compose \
	       circleci \
	       python \
	       vim
	       gcc
	       jq
	       make
	      )

for i in ${PACKAGE_LIST[@]}; do
	which ${i} > /dev/null 2>&1
	if [ ! $? -eq 0 ]; then
		echo Pacage ${i} : NG
		cat <<"EOS"
Please install Package!
EOS
		ERR_FLAG=1
	else
		echo "Package ${i} : OK"
	fi
	usleep 50000
done

DOCKER_VERSION=`docker --version | awk '{print $3}' | sed -e 's/,$//g'`
DOCKER_COMPOSE_VERSION=`docker-compose --version | awk '{print $3}' | sed -e 's/\,//g'`
CIRCLECI_VERSION=`circleci --version`

systemctl status docker.service > /dev/null 2>&1
if [ ! $? -eq 0 ]; then
	abrt "Please start the Docker daemon"
fi
