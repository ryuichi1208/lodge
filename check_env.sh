#!/bin/bash
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

PACKAGE_LIST=(  docker \
       		docker-compose \
	        circleci \
	       	python \
	       	vim \
	       	gcc \
	       	jq \
	       	make
)

VERSION=1.0.0

if [ ! "${EUID}" -eq 0 ] ; then
	echo "Error: Pleas do run root!"
	exit 1
fi

function usage_exit()
{
	cat << EOF
Usage:
$(basename $0) [-d|-v]
$(basename $0) -h
Options:
-h	Print this help
-d	Exec debug mode
-v      Print version
EOF
}

# @param : Err Message
function abort_exit()
{
	local status=$?
	echo "$@" 1>&2
	exit 1
}

function get_os_info()
{
	local OS=""
	if [ "$(uname)" == 'Darwin' ]; then
		OS='Mac'
	elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
		OS='Linux'
	elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
		OS='Cygwin'
	fi

	if [ ${OS} != "Linux" ]; then
		abort_exit "Your OS is not supported! : ${OS}"
	fi
}

while getopts hvd OPT
do
	case $OPT in
		h) usage_exit
		;;
		d) set -ex
		;;
		v) echo "$VERSION"
		   exit 0
		;;
		\?) usage_exit
		;;
	esac
done

function main() {

	get_os_info

	for i in ${PACKAGE_LIST[@]}; do
		which ${i} > /dev/null 2>&1
		if [ ! $? -eq 0 ]; then
			abort_exit "Please install ${i}!"
		else
			echo "Package ${i} : OK"
		fi
		usleep 50000
	done

	DOCKER_VERSION=$(docker --version | awk '{print $3}' | sed -e 's/,$//g')
	DOCKER_COMPOSE_VERSION=$(docker-compose --version | awk '{print $3}' | sed -e 's/\,//g')
	CIRCLECI_VERSION=$(circleci --version)
	MAKE_VERSION=$(make --version | grep GNU | awk '{print $3}')

	systemctl status docker.service > /dev/null 2>&1
	if [ ! $? -eq 0 ]; then
		abrt "Please start the Docker daemon"
	fi
}

main "$@"
exit
