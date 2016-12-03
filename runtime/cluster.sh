#!/bin/bash
set -e
source ${ZATO_APP_HOME}/env-defaults

${ZATO_BINDIR}/zato create cluster --odb_host ${DB_HOST} --odb_port ${DB_PORT} \
                                    --odb_user ${DB_USER} --odb_db_name ${DB_NAME} \
                                    --odb_password ${DB_PASS} --tech_account_password \
                                    ${ADMIN_PASS} postgresql ${LB_HOST} ${LB_PORT} ${LB_AGENT_PORT} \
                                    ${BROKER_HOST} ${BROKER_PORT} ${CLUSTER_NAME} ${ADMIN_USER}
