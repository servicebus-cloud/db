#!/bin/bash
set -e
source ${ZATO_APP_HOME}/functions

[[ ${DEBUG} == true ]] && set -x

# allow arguments to be passed to zato
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == zato || ${1} == $(which zato) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch postgres
if [[ -z ${1} ]]; then
  map_uidgid

  echo "Starting ServiceBus DB..."
  exec start-stop-daemon --start --chuid ${ZATO_USER}:${ZATO_USER} \
    --exec ${ZATO_BINDIR}/zato -- create odb --odb_host ${DB_HOST} --odb_port ${DB_PORT} --odb_user ${DB_USER} --odb_db_name ${DB_NAME} --odb_password ${DB_PASS} postgresql

  echo "Starting ServiceBus Cluster..."
  exec start-stop-daemon --start --chuid ${ZATO_USER}:${ZATO_USER} \
    --exec ${ZATO_BINDIR}/zato -- create cluster --odb_host ${DB_HOST} --odb_port ${DB_PORT} --odb_user ${DB_USER} --odb_db_name ${DB_NAME} --odb_password ${DB_PASS} --tech_account_password ${ADMIN_PASS} postgresql ${LB_HOST} ${LB_PORT} ${LB_AGENT_PORT} ${BROKER_HOST} ${BROKER_PORT} ${CLUSTER_NAME} ${ADMIN_USER}

else
  exec "$@"
fi
