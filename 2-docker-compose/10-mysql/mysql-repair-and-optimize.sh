#!/usr/bin/env bash
# Backup MySQL DB to file

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# read variables from .env-file
source ${DIR}/.env
#cat ${MYSQL_DATABASE}
#SQL_H="127.0.0.1"
#SQL_DB=${MYSQL_DATABASE}
#SQL_U=${MYSQL_USER}
#SQL_P=${MYSQL_PASSWORD}

# Get current date & time
# cur_date=$(get_date)
# cur_date=$(get_date "10 minute ago")
function get_date {
  # '2018-10-08 10:49:28 +0500'
  DATE_FORMAT="+'%Y-%m-%d %H:%M:%S %z'"
  # ISO 8601
  # date +'%Y-%m-%dT%H:%M:%S%z'
  # '2018-10-08T10:49:28+0500'
  # date -u +'%Y-%m-%dT%H:%M:%SZ'
  # '2018-10-08T05:49:28Z'
  if [ -z "$1" ]; then
    cmd="date $DATE_FORMAT";
  else
    cmd="date -d '$@' $DATE_FORMAT";
  fi
  eval "${cmd}"
}
# log Message
function log_msg {
  dt=$(get_date)
  echo "[$dt]: $1"
}
log_msg "-- Optimize all MySQL DBs ---"

cmd="time docker-compose exec -T mysql mysqlcheck -u root -p${MYSQL_ROOT_PASSWORD} --auto-repair --optimize --all-databases"
#echo ${cmd}
eval "${cmd}"

log_msg '-- Optimization of all MySQL DBs completed --'
