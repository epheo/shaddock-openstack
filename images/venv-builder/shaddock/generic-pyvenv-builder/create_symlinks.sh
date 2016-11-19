#!/bin/bash

mkdir -p /opt/openstack/services

SRV_LIST=`ls /opt/openstack/venv \
           |rev \
           |cut -d '-' -f 2- \
           |rev \
           |uniq`

for SRV in $SRV_LIST
do
  VENV_DIR=`ls /opt/openstack/venv/ \
             |grep $SRV'-' \
             |sort -r \
             |head -n1`
  ln -snf /opt/openstack/venv/$VENV_DIR /opt/openstack/services/$SRV
done
