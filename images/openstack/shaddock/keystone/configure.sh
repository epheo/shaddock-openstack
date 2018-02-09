#!/bin/bash

sleep 20 # for mysql to come up after being reachable

CONSTRAINTS=/opt/openstack/services/keystone/upper-constraints.txt
pip install -c $CONSTRAINTS pymysql

echo "> Creating $SERVICE database"
echo "> DB: $MYSQL_VIP"
echo "> User: $MYSQL_USER"
echo "> Password $MYSQL_PASS"

mysql  -h$MYSQL_VIP -u$MYSQL_USER -p$MYSQL_PASS \
       -e "CREATE DATABASE keystone;"

mysql  -h$MYSQL_VIP -u$MYSQL_USER -p$MYSQL_PASS \
       -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
           IDENTIFIED BY '$KEYSTONE_DB_PASS';"

mysql  -h$MYSQL_VIP -u$MYSQL_USER -p$MYSQL_PASS \
       -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
           IDENTIFIED BY '$KEYSTONE_DB_PASS'"


echo "> Using tox-generated config files"
cp /etc/keystone/keystone.conf.sample /etc/keystone/keystone.conf
mkdir -p /etc/keystone/fernet-keys/


echo "> Writing configuration files"
s='crudini --set /etc/keystone/keystone.conf'

$s database connection \
  "mysql+pymysql://keystone:$KEYSTONE_DB_PASS@$MYSQL_VIP/keystone"
$s token provider fernet 


echo "> Updating database tables"; keystone-manage db_sync 


echo "> Initializing Fernet keys"
keystone-manage fernet_setup \
  --keystone-user root \
  --keystone-group root

keystone-manage credential_setup \
  --keystone-user root \
  --keystone-group root


echo "> Bootstraping Keystone with:"
echo "Password = $ADMIN_PASS"
echo "Endpoint = $KEYSTONE_VIP"

keystone-manage bootstrap \
    --bootstrap-password $ADMIN_PASS \
    --bootstrap-admin-url http://$KEYSTONE_VIP:35357/v3/ \
    --bootstrap-internal-url http://$KEYSTONE_VIP:5000/v3/ \
    --bootstrap-public-url http://$KEYSTONE_VIP:5000/v3/ \
    --bootstrap-region-id RegionOne


echo "[done]"
