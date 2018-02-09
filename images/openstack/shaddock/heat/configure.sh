#!/bin/bash

OS_CLI=/opt/openstack/services/python-openstackclient/bin/openstack
HEAT_PATH=/opt/openstack/services/glance/bin/

echo "Updating conf file..."
$HEAT_PATH/python /opt/configparse.py

source /opt/openstack/service.osrc

endpoint=`$OS_CLI endpoint list -f csv -q |grep heat`

if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not yet created"
    echo "Creating database"
    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "CREATE DATABASE heat;"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' \
            IDENTIFIED BY '${HEAT_DBPASS}';"

    mysql \
        -h${MYSQL_HOST_IP} \
        -u${MYSQL_USER} \
        -p${MYSQL_PASSWORD} \
        -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' \
            IDENTIFIED BY '${HEAT_DBPASS}'"


    echo "Creating heat user..."
    $OS_CLI user create --domain default --password ${HEAT_PASS} heat

    $OS_CLI role add --project service --user heat admin

    echo "Registering heat API and EndPoints..."
    $OS_CLI service create --name heat \
        --description "OpenStack Orchestration" orchestration

    $OS_CLI service create --name heat-cfn \
    --description "OpenStack Orchestration" cloudformation


    $OS_CLI endpoint create --region RegionOne \
        orchestration public http://${KEYSTONE_API_IP}:8004/v1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        orchestration internal http://${KEYSTONE_API_IP}:8004/v1/%\(tenant_id\)s

    $OS_CLI endpoint create --region RegionOne \
        orchestration admin http://${KEYSTONE_API_IP}:8004/v1/%\(tenant_id\)s


    $OS_CLI endpoint create --region RegionOne \
        cloudformation public http://${KEYSTONE_API_IP}:8000/v1

    $OS_CLI endpoint create --region RegionOne \
        cloudformation internal http://${KEYSTONE_API_IP}:8000/v1

    $OS_CLI endpoint create --region RegionOne \
        cloudformation admin http://${KEYSTONE_API_IP}:8000/v1

    $OS_CLI domain create --description "Stack projects and users" heat
    $OS_CLI user create --domain heat \
        --password ${HEAT_PASS} heat_domain_admin
    $OS_CLI role add --domain heat --user-domain heat \
        --user heat_domain_admin admin
    $OS_CLI role create heat_stack_owner
    $OS_CLI role add --project demo --user demo heat_stack_owner
    $OS_CLI role create heat_stack_user

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
$HEAT_PATH/heat-manage db_sync

echo "Starting heat using supervisord..."
exec /usr/bin/supervisord -n
