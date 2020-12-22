#!/bin/sh

dirs="data conf logs backups"

for dir in ${dirs}
do
  echo "Delete folder - ${dir}"
  sudo rm -rf ${dir}
done
