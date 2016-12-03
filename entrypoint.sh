#!/bin/bash
set +e
source ${ZATO_APP_HOME}/env-defaults
source ${ZATO_APP_HOME}/functions

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

[[ ${DEBUG} == true ]] && set -x

# allow arguments to be passed to zato
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == zato || ${1} == $(which zato) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

function finish {
    echo ""
}

trap finish EXIT

ARGS=" "
NAME=zato
LOG_FILE=${ZATO_HOME}/boot
do_start()
{
  if [[ -n "$1" ]] ; then
    echo "Starting ServiceBus ${1}..."

    start-stop-daemon --start --exec ${2} -- ${3} >> ${LOG_FILE}.out 2>> ${LOG_FILE}.err || true

    cat ${LOG_FILE}.out
    cat ${LOG_FILE}.err

    echo "" > ${LOG_FILE}.out
    echo "" > ${LOG_FILE}.err
  fi
}

# default behaviour is to launch postgres
if [[ -z ${1} ]]; then
  map_uidgid

  do_start "DB" "${ZATO_APP_HOME}/db.sh" $ARGS

  do_start "Cluster" "${ZATO_APP_HOME}/cluster.sh" $ARGS

  log_end_msg 0
else
  exec "$@"
fi
