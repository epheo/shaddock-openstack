#!/bin/bash

d=/opt/openstack/services

mkdir $d && cd $d

srv_list=`ls /opt/openstack/venv \
           |rev \
           |cut -d '-' -f 2- \
           |rev \
           |uniq`

for srv in $srv_list
do
  venv_dir=`ls /opt/openstack/venv/ \
             |grep $srv'-' \
             |sort -r \
             |head -n1`
  ln -sf ../venv/$venv_dir $srv
done
