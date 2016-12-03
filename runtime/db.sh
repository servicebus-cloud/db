#!/bin/bash
set -e
source ${ZATO_APP_HOME}/env-defaults

${ZATO_BINDIR}/zato create odb --odb_host ${DB_HOST} --odb_port ${DB_PORT} \
                                --odb_user ${DB_USER} --odb_db_name ${DB_NAME} --odb_password ${DB_PASS} postgresql
