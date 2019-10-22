#!/usr/bin/env bash
# Restore MySQL DB from file

#DATE=$(date +%Y-%m-%d)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# read variables from .env-file
source "${DIR}"/.env
#cat ${MYSQL_DATABASE}
SQL_H="127.0.0.1"
SQL_DB=${MYSQL_DATABASE}
SQL_U=${MYSQL_USER}
SQL_P=${MYSQL_PASSWORD}
# Dirs
BCK_DIR=${DIR}/sql_dumps
#mkdir -p "${BCK_DIR}"
#BCK_ARC=${BCK_DIR}/${SQL_DB}-${DATE}.sql.gz
BCK_LAST=${BCK_DIR}/${SQL_DB}-last.sql.gz

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

log_msg "-- Restore MySQL DB '${SQL_DB}' ---"

#cmd="time docker-compose exec -T mysql mysqldump -h ${SQL_H} -u ${SQL_U} -p${SQL_P} ${SQL_DB} | gzip > ${BCK_DIR}/${BCK_ARC_FILE}"
cmd="time gunzip < ${BCK_LAST} | docker-compose exec -T mysql mysql -h ${SQL_H} -u ${SQL_U} -p${SQL_P} ${SQL_DB}"
#echo ${cmd}
eval "${cmd}"

log_msg "-- Analyze of each MySQL table in the DB '${SQL_DB}' ---"
cmd="time docker-compose exec -T mysql mysqlcheck -u ${SQL_U} -p${SQL_P} ${SQL_DB} -a"
#cmd="time docker-compose exec -T mysql mysqlcheck -u root -p${MYSQL_ROOT_PASSWORD} --auto-repair --optimize --all-databases"
#echo ${cmd}
eval "${cmd}"

log_msg '-- Done --'
