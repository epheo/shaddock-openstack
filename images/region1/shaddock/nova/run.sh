#!/bin/bash

CONSTRAINTS=/opt/openstack/services/nova/upper-constraints.txt

rm -rf /etc/nova/*
cp -r /opt/openstack/services/nova/etc/nova/* /etc/nova/
mv /etc/nova/nova.conf.sample /etc/nova/nova.conf

pip install -c $CONSTRAINTS pymysql

source /opt/openstack/osrc/service.osrc
endpoint=`openstack endpoint list -f csv -q |grep nova`

if [ -z "$endpoint" ]
then
    echo ">>>>>>> Endpoint not created"
    echo "Creating database nova"
    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "CREATE DATABASE nova;"
    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "CREATE DATABASE nova_api;"
    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "CREATE DATABASE nova_cell0;"

    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
              IDENTIFIED BY '${NOVA_DB_PASS}';"
    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
              IDENTIFIED BY '${NOVA_DB_PASS}';"

    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
              IDENTIFIED BY '${NOVA_DB_PASS}';"
    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
              IDENTIFIED BY '${NOVA_DB_PASS}';"

    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
              IDENTIFIED BY '${NOVA_DB_PASS}';"
    mysql -h${MYSQL_VIP} -u${MYSQL_USER} -p${MYSQL_PASS} \
          -e "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
              IDENTIFIED BY '${NOVA_DB_PASS}';"


    echo "Creating Nova user..."
    openstack user create --domain default --password ${NOVA_PASS} nova
    openstack role add --project service --user nova admin

    echo "Registering Nova API and EndPoints..."
    openstack service create --name nova \
        --description "OpenStack Compute" compute

    openstack endpoint create --region RegionOne \
        compute public http://${NOVA_VIP}:8774/v2.1/%\(tenant_id\)s
    openstack endpoint create --region RegionOne \
        compute internal http://${NOVA_VIP}:8774/v2.1/%\(tenant_id\)s
    openstack endpoint create --region RegionOne \
        compute admin http://${NOVA_VIP}:8774/v2.1/%\(tenant_id\)s

    openstack user create --domain default --password ${NOVA_PASS} placement
    openstack role add --project service --user placement admin

    openstack service create --name placement \
                             --description "Placement API" placement
       
    openstack endpoint create --region RegionOne \
      placement public http://${NOVA_VIP}:8778
    openstack endpoint create --region RegionOne \
      placement internal http://${NOVA_VIP}:8778
    openstack endpoint create --region RegionOne \
      placement admin http://${NOVA_VIP}:8778

    echo "Testing Nova..."
    #openstack compute service list
    openstack endpoint list

else

    if [[ $endpoint == *"ERROR"* ]]
    then
        echo ">>>>>>> Cannot connect to Keystone"
        exit
    else
        echo ">>>>>>> Endpoint already created"
        echo "Testing Nova..."
        openstack compute service list
        openstack endpoint list
    fi
fi

crudini --set /etc/nova/nova.conf DEFAULT enabled_apis osapi_compute,metadata

crudini --set /etc/nova/nova.conf api_database \
  connection "mysql+pymysql://nova:$NOVA_DB_PASS@$MYSQL_VIP/nova_api"
crudini --set /etc/nova/nova.conf database \
  connection "mysql+pymysql://nova:$NOVA_DB_PASS@$MYSQL_VIP/nova"

crudini --set /etc/nova/nova.conf DEFAULT \
  transport_url "rabbit://$RABBIT_USER:$RABBIT_PASS@$RABBIT_VIP"

crudini --set /etc/nova/nova.conf api auth_strategy keystone

crudini --set /etc/nova/nova.conf keystone_authtoken \
  auth_uri "http://$KEYSTONE_VIP:5000"
crudini --set /etc/nova/nova.conf keystone_authtoken \
  auth_url  "http://$KEYSTONE_VIP:35357"
crudini --set /etc/nova/nova.conf keystone_authtoken \
  memcached_servers "$MEMCACHED_IP:11211"
crudini --set /etc/nova/nova.conf keystone_authtoken auth_type  password
crudini --set /etc/nova/nova.conf keystone_authtoken \
  project_domain_name default
crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_name default
crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
crudini --set /etc/nova/nova.conf keystone_authtoken username nova
crudini --set /etc/nova/nova.conf keystone_authtoken password $NOVA_PASS


crudini --set /etc/nova/nova.conf DEFAULT my_ip $NOVA_VIP 
crudini --set /etc/nova/nova.conf DEFAULT use_neutron True
crudini --set /etc/nova/nova.conf DEFAULT \
  firewall_driver nova.virt.firewall.NoopFirewallDriver

crudini --set /etc/nova/nova.conf vnc enabled True
crudini --set /etc/nova/nova.conf vnc vncserver_listen $NOVA_VIP
crudini --set /etc/nova/nova.conf vnc vncserver_proxyclient_address $NOVA_VIP

crudini --set /etc/nova/nova.conf glance \
  api_servers "http://$GLANCE_VIP:9292"
crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/run/nova


crudini --set /etc/nova/nova.conf placement os_region_name  RegionOne
crudini --set /etc/nova/nova.conf placement project_domain_name  Default
crudini --set /etc/nova/nova.conf placement project_name  service
crudini --set /etc/nova/nova.conf placement auth_type  password
crudini --set /etc/nova/nova.conf placement user_domain_name  Default
crudini --set /etc/nova/nova.conf placement auth_url  \
  "http://$NOVA_VIP:35357/v3"
crudini --set /etc/nova/nova.conf placement username  placement
crudini --set /etc/nova/nova.conf placement password  $NOVA_PASS

echo "Create databases tables"

nova-manage api_db sync
nova-manage cell_v2 map_cell0
nova-manage cell_v2 create_cell --name=cell1 --verbose
nova-manage db sync
