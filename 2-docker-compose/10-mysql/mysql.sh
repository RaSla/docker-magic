#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# read variables from .env-file
source ${DIR}/.env

echo "Connecting to MySQL with 'root' user:"
docker-compose exec mysql  mysql -u root -p${MYSQL_ROOT_PASSWORD}
