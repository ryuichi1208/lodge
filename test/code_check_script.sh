#!/bin/bash

################################################################
#                                                              #
# FileName: code_check_script.sh                               #
# Discription:                                                 #
#    Code Check Script.                                        #
#    Call by test_script.sh                                    #
#                                                              #
################################################################

# Usage function
function usage(){
  cat << EOS
Usage: code_check_script.sh -s <FILE> -p <FILE> -a <FILE>
       code_check_script.sh --src-code <FILE> --problem <FILE> --answer <FILE>
       code_check_script.sh --help

Input option:
  -s, --src-code             Specify the source code file.
  -p, --problem              Specify the problem file.
  -a, --answer               Specify the answer file.
  -h, --help                 Display this help and exit.
EOS
}

# Logger function
# ToDo: メインのほうで使用？
# function logger(){
#   echo "${1}" >> "${LOG_PATH}"
# }

# Argument check

SCRIPT_NAME="$( basename $0 )"

for OPT in "$@"; do
  case "${OPT}" in
    '-s' | '--src-code')
      if [[ -z "$2" ]] || [[ "$2" =~ ^--+ ]]; then
        echo "${SCRIPT_NAME}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
        usage
        exit 1
      fi
      FLAG_SRC=1
      SRC_FILE=${2}
      shift 2
    ;;
    '-p' | '--problem')
      if [[ -z "$2" ]] || [[ "$2" =~ ^--+ ]]; then
        echo "${SCRIPT_NAME}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
        usage
        exit 1
      fi
      FLAG_PROB=1
      PROPLEM_FILE=${2}
      shift 2
    ;;
    '-a' | '--answer')
      if [[ -z "$2" ]] || [[ "$2" =~ ^--+ ]]; then
        echo "${SCRIPT_NAME}: option requires an argument -- $( echo $1 | sed 's/^-*//' )" 1>&2
        usage
        exit 1
      fi
      FLAG_ANS=1
      ANSWER_FILE=${2}
      shift 2
    ;;
    '-h' | '--help')
      usage
      exit 0
    ;;
    '-*' | '--*' )
      echo "${SCRIPT_NAME}: Invalid option -- '$( echo $1 | sed 's/^-*//' )'" 1>&2
      usage
      exit 1
    ;;
   esac
done

if [[ ${FLAG_SRC:-0} -eq 0 ]]; then
  echo "${SCRIPT_NAME}: Option not specified." 1>&2
  usage
  exit 1
fi
if [[ ${FLAG_PROB:-0} -eq 0 ]]; then
  echo "${SCRIPT_NAME}: Option not specified." 1>&2
  usage
  exit 1
fi
if [[ ${FLAG_ANS:-0} -eq 0 ]]; then
  echo "${SCRIPT_NAME}: Option not specified." 1>&2
  usage
  exit 1
fi

# Function
function python_test(){
    PY_BASE_CMD="$( which python3.6 )"
    PY_CMD="${PY_BASE_CMD} ${1} < ${2}"

    eval ${PY_CMD}
    RC=$?

    if [[ ${DEBUG} == 1 ]]; then
        echo "[DEBUG] Following command. Command: ${CMD}"
    fi

    if [[ ${RC} != 0 ]]; then
        echo "[ERROR] Failed to python command. Command: ${CMD}"
        exit 1
    fi

}

EXEC_RESULT=$( python_test ${SRC_FILE} ${PROPLEM_FILE} )

ANS="$( cat ${ANSWER_FILE} )"
if [[ ${EXEC_RESULT} != ${ANS} ]]; then
    echo "[ERROR] Bad code result. RESULT: ${EXEC_RESULT}"
    exit 1
fi

exit 0
