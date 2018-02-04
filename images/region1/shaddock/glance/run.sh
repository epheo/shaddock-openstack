#!/bin/bash

rm /var/lib/glance/glance.sqlite

CONSTRAINTS=/opt/openstack/services/glance/upper-constraints.txt
pip install -c $CONSTRAINTS pymysql
pip install -c $CONSTRAINTS python-memcached

rm -rf /etc/glance/*
cp -r /opt/openstack/services/glance/etc/* /etc/glance/

source /opt/openstack/osrc/service.osrc

if [ -z `openstack prject list -f csv -q |grep service` ]
then
      openstack project create service
fi

endpoint=`openstack endpoint list -f csv -q |grep glance`
if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not yet created"
    echo "Creating database"
mysql  -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
        -e "CREATE DATABASE glance;"

mysql  -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
        -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
            IDENTIFIED BY '${GLANCE_DB_PASS}';"

mysql  -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
        -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
            IDENTIFIED BY '${GLANCE_DB_PASS}'"


    echo "Creating Glance user..."
    openstack user create --domain default --password ${GLANCE_PASS} glance

    openstack role add --project service --user glance admin

    echo "Registering Glance API and EndPoints..."
    openstack service create --name glance \
        --description "OpenStack Image" image
    openstack endpoint create --region RegionOne \
        image public http://${GLANCE_VIP}:9292
    openstack endpoint create --region RegionOne \
        image internal http://${GLANCE_VIP}:9292
    openstack endpoint create --region RegionOne \
        image admin http://${GLANCE_VIP}:9292

else

    if [[ $endpoint == *"ERROR"* ]]
    then
        echo "> Cannot connect to Keystone"
        exit
    else
        echo "> Endpoint already created"
    fi
fi

crudini --set /etc/glance/glance-api.conf database connection \
  "mysql+pymysql://glance:$GLANCE_DB_PASS@$MYSQL_VIP/glance"

crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_uri \
  "http://$KEYSTONE_VIP:5000"
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_url \
  "http://$KEYSTONE_VIP:35357"
crudini --set /etc/glance/glance-api.conf keystone_authtoken memcached_servers \
  $MEMCACHED_VIP:11211
crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_type password
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_name \
  default
crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_name \
  default
crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
crudini --set /etc/glance/glance-api.conf keystone_authtoken password $GLANCE_PASS

crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone

crudini --set /etc/glance/glance-api.conf glance_store stores file,http
crudini --set /etc/glance/glance-api.conf glance_store default_store file
crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir \
  '/var/lib/glance/images/'

# Glance registry
crudini --set /etc/glance/glance-registry.conf database connection \
  "mysql+pymysql://glance:$GLANCE_DB_PASS@$MYSQL_VIP/glance"

crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  auth_uri "http://$KEYSTONE_VIP:5000"
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  auth_url "http://$KEYSTONE_VIP:35357"
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  memcached_servers $MEMCACHED_VIP:11211
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  auth_type password
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  project_domain_name default
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  user_domain_name default
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  project_name service
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  username glance
crudini --set /etc/glance/glance-registry.conf keystone_authtoken \
  password $GLANCE_PASS

crudini --set /etc/glance/glance-registry.conf paste_deploy flavor keystone

echo "Create database tables"
glance-manage db_sync
