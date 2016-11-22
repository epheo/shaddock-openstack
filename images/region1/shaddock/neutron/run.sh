#!/bin/bash

NEUTRON_PATH=/opt/openstack/services/neutron/bin/
OS_CLI=/opt/openstack/services/python-openstackclient/bin/openstack

ln -s /opt/openstack/services/neutron/etc/ /etc/neutron
mv /etc/neutron/neutron.conf.sample /etc/neutron/neutron.conf

echo "Updating conf file..."
$NEUTRON_PATH/python /opt/configparse.py

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${ADMIN_PASS}
export OS_AUTH_URL=http://${KEYSTONE_API_IP}:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

endpoint=`$OS_CLI endpoint list -f csv -q |grep neutron`

if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not created"
    echo "Creating database neutron"
    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "CREATE DATABASE neutron;"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
            IDENTIFIED BY '${NEUTRON_DBPASS}';"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
            IDENTIFIED BY '${NEUTRON_DBPASS}';"

    echo "Creating Neutron user..."
    $OS_CLI user create --domain default --password ${NEUTRON_PASS} neutron

    $OS_CLI role add --project service --user neutron admin

    echo "Registering Neutron API and EndPoints..."
    $OS_CLI service create --name neutron \
        --description "OpenStack Networking" network

    $OS_CLI endpoint create --region RegionOne \
        network public http://${KEYSTONE_API_IP}:9696

    $OS_CLI endpoint create --region RegionOne \
        network internal http://${KEYSTONE_API_IP}:9696

    $OS_CLI endpoint create --region RegionOne \
        network admin http://${KEYSTONE_API_IP}:9696

    echo "Testing Neutron..."
    #neutron ext-list

else

    if [[ $endpoint == *"ERROR"* ]]
    then
        echo ">>>>>>> Cannot connect to Keystone"
        exit
    else
        echo ">>>>>>> Endpoint already created"
        echo "Testing Neutron..."
        #neutron ext-list
    fi
fi

echo "Create databases tables"
$NEUTRON_PATH/neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head

echo "Starting nova using supervisord..."
exec /usr/bin/supervisord -n
