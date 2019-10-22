#!/usr/bin/env bash
# Backup MySQL DB to file

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M-%S)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# read variables from .env-file
source ${DIR}/.env
#cat ${MYSQL_DATABASE}
SQL_H="127.0.0.1"
SQL_DB=${MYSQL_DATABASE}
SQL_U=${MYSQL_USER}
SQL_P=${MYSQL_PASSWORD}
# Dirs
BCK_DIR=${DIR}/sql_dumps
mkdir -p "${BCK_DIR}"
BCK_ARC_FILE=${SQL_DB}-${DATE}_${TIME}.sql.gz
BCK_LAST_FILE=${SQL_DB}-last.sql.gz

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
log_msg "-- Backup MySQL DB '${SQL_DB}' ---"

#cmd="time docker-compose exec -T mysql mysqldump --all-databases -uroot -p$MYSQL_ROOT_PASSWORD > gzip | /some/path/on/your/host/all-databases.sql"
cmd="time docker-compose exec -T mysql mysqldump -h ${SQL_H} -u ${SQL_U} -p${SQL_P} ${SQL_DB} | gzip > ${BCK_DIR}/${BCK_ARC_FILE}"
#echo ${cmd}
eval "${cmd}"

log_msg '-- Backup MySQL-dump is done --'

log_msg '-- Verify successful completion of database dump --'
cmd="zcat ${BCK_DIR}/${BCK_ARC_FILE} | tail -n 1 | grep 'Dump completed' | wc -l"
echo "${cmd}"
res=$(eval ${cmd})

if [ "${res}" = "1" ]; then
  log_msg '-- Dump is OK. Creating link to the last MySQL-dump --'
  cd "${BCK_DIR}"
  cmd="ln -sf ${BCK_ARC_FILE} ${BCK_LAST_FILE}"
  echo "${cmd}"
  eval "${cmd}"
  cd "${DIR}"
else
  log_msg "[ERROR] MySQL dump is NOT completed !"
fi

log_msg '-- Done --'
