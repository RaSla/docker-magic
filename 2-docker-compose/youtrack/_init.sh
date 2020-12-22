#!/bin/sh

dirs="data conf logs backups"

for dir in ${dirs}
do
  echo "Create folder - ${dir}"
  mkdir -p -m 750 ${dir}
  sudo chown -R 13001:13001 ${dir}
done
