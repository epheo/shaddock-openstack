#!/bin/bash

echo "Removing glance DB..."
rm /var/lib/glance/glance.sqlite

GLANCE_PATH=/opt/openstack/services/glance/bin/
OS_CLI=/opt/openstack/services/python-openstackclient/bin/openstack

ln -s /opt/openstack/services/glance/etc/ /etc/glance

echo "Updating conf file..."
$GLANCE_PATH/python /opt/configparse.py

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_AUTH_URL=http://${KEYSTONE_API_IP}:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

svc_project=`$OS_CLI project list -f csv -q |grep service`
if [ -z "svc_project" ]
then
    $OS_CLI project create service
fi

endpoint=`$OS_CLI endpoint list -f csv -q |grep glance`
if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not yet created"
    echo "Creating database"
    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "CREATE DATABASE glance;"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
            IDENTIFIED BY '${GLANCE_DBPASS}';"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
            IDENTIFIED BY '${GLANCE_DBPASS}'"


    echo "Creating Glance user..."
    $OS_CLI user create --domain default --password ${GLANCE_PASS} glance

    $OS_CLI role add --project service --user glance admin

    echo "Registering Glance API and EndPoints..."
    $OS_CLI service create --name glance \
        --description "OpenStack Image" image

    $OS_CLI endpoint create --region RegionOne \
        image public http://${GLANCE_API_IP}:9292

    $OS_CLI endpoint create --region RegionOne \
        image internal http://${GLANCE_API_IP}:9292

    $OS_CLI endpoint create --region RegionOne \
        image admin http://${GLANCE_API_IP}:9292

else

    if [[ $endpoint == *"ERROR"* ]]
    then
        echo ">>>>>>> Cannot connect to Keystone"
        exit
    else
        echo ">>>>>>> Endpoint already created"
    fi
fi

echo "Create database tables"
source $GLANCE_PATH/activate
pip install pymysql
pip install python-memcached
$GLANCE_PATH/glance-manage db_sync
deactivate

echo "Starting glance using supervisord..."
exec /usr/bin/supervisord -n

#mkdir /tmp/images
#wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
#openstack image create --disk-format qcow2 --container-format bare --public --file /tmp/images/cirros-0.3.4-x86_64-disk.img cirros-0.3.4-x86_64
#openstack image list
