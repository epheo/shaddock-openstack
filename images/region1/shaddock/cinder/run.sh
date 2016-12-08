#!/bin/bash

CINDER_PATH=/opt/openstack/services/cinder/bin/
OS_CLI=/opt/openstack/services/python-openstackclient/bin/openstack

ln -s /opt/openstack/services/cinder/etc/cinder /etc/cinder

echo "Updating conf file..."
$CINDER_PATH/python /opt/configparse.py

source /opt/openstack/service.osrc

endpoint=`$OS_CLI endpoint list -f csv -q |grep cinder`

if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not yet created"
    echo "Creating database"
    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "CREATE DATABASE cinder;"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
            IDENTIFIED BY '${CINDER_DBPASS}';"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
            IDENTIFIED BY '${CINDER_DBPASS}'"


    echo "Creating Cinder user..."
    $OS_CLI user create --domain default --password ${CINDER_PASS} cinder

    $OS_CLI role add --project service --user cinder admin

    echo "Registering Cinder API and EndPoints..."
    $OS_CLI service create --name cinder \
        --description "OpenStack Block Storage" volume

    $OS_CLI service create --name cinderv2 \
        --description "OpenStack Block Storage" volumev2

    $OS_CLI endpoint create --region RegionOne \
        volume public http://${CINDER_API_IP}:8776/v1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        volume internal http://${CINDER_API_IP}:8776/v1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        volume admin http://${CINDER_API_IP}:8776/v1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        volumev2 public http://${CINDER_API_IP}:8776/v2/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        volumev2 internal http://${CINDER_API_IP}:8776/v2/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        volumev2 admin http://${CINDER_API_IP}:8776/v2/%\(tenant_id\)s

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
$CINDER_PATH/cinder-manage db sync

echo "Starting cinder using supervisord..."
exec /usr/bin/supervisord -n
