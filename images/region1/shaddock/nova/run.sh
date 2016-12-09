#!/bin/bash

NOVA_PATH=/opt/openstack/services/nova
OS_CLI=/opt/openstack/services/python-openstackclient/bin/openstack

ln -s $NOVA_PATH/etc/nova /etc/nova
cp /etc/nova/nova.conf.sample /etc/nova/nova.conf

echo "Updating conf file..."
$NOVA_PATH/bin/python /opt/configparse.py

source /opt/openstack/service.osrc

endpoint=`$OS_CLI endpoint list -f csv -q |grep nova`

if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not created"
    echo "Creating database nova"
    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "CREATE DATABASE nova;"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
            IDENTIFIED BY '${NOVA_DBPASS}';"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
            IDENTIFIED BY '${NOVA_DBPASS}';"

    echo "Creating database nova_api"
    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "CREATE DATABASE nova_api;"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
            IDENTIFIED BY '${NOVA_DBPASS}';"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
            IDENTIFIED BY '${NOVA_DBPASS}';"

    echo "Creating Nova user..."
    $OS_CLI user create --domain default --password ${NOVA_PASS} nova

    $OS_CLI role add --project service --user nova admin

    echo "Registering Nova API and EndPoints..."
    $OS_CLI service create --name nova \
        --description "OpenStack Compute" compute

    $OS_CLI endpoint create --region RegionOne \
        compute public http://${NOVA_API_IP}:8774/v2.1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        compute internal http://${NOVA_API_IP}:8774/v2.1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        compute admin http://${NOVA_API_IP}:8774/v2.1/%\(tenant_id\)s

    echo "Testing Nova..."
    #openstack compute service list
    $OS_CLI endpoint list

else

    if [[ $endpoint == *"ERROR"* ]]
    then
        echo ">>>>>>> Cannot connect to Keystone"
        exit
    else
        echo ">>>>>>> Endpoint already created"
        echo "Testing Nova..."
        $OS_CLI compute service list
        $OS_CLI endpoint list
    fi
fi

echo "Create databases tables"

$NOVA_PATH/bin/nova-manage api_db sync
$NOVA_PATH/bin/nova-manage db sync

echo "Starting nova using supervisord..."
exec /usr/bin/supervisord -n
