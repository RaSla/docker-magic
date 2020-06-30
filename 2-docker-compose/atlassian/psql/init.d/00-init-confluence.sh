#!/bin/sh
set -e

echo "$0 - BEGIN"

echo "$0 - INFO"
whoami
id

echo "$0 - CONFLUENCE: create Table & User"
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" <<-EOSQL
    CREATE USER ${CONFLU_USER} WITH PASSWORD '${CONFLU_PASSWORD}' LOGIN;
    CREATE DATABASE ${CONFLU_DB};
    GRANT ALL PRIVILEGES ON DATABASE "${CONFLU_DB}" TO ${CONFLU_USER};
EOSQL

echo "$0 - DONE"