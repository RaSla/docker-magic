#!/bin/sh
set -e

echo "$0 - BEGIN"

echo "$0 - INFO"
whoami
id

echo "$0 - JIRA: create Table & User"
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CREATE USER ${JIRA_USER} WITH PASSWORD '${JIRA_PASSWORD}' LOGIN;
    CREATE DATABASE ${JIRA_DB};
    GRANT ALL PRIVILEGES ON DATABASE "${JIRA_DB}" TO ${JIRA_USER};
EOSQL

echo "$0 - DONE"