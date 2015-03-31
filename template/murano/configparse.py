#!/usr/bin/env python
# -*- coding: utf-8 -*-

#    Copyright (C) 2014 Thibaut Lapierre <root@epheo.eu>. All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

from configparser import ConfigParser
import os

configfile = '/murano/murano/etc/murano/murano.conf.sample'
config = ConfigParser()
config.read(configfile)

config['DEFAULT']['debug'] = os.environ.get('ADMIN_TOKEN')
config['DEFAULT']['verbose'] = os.environ.get('ADMIN_TOKEN')
config['DEFAULT']['rabbit_host'] = os.environ.get('ADMIN_TOKEN')
config['DEFAULT']['rabbit_userid'] = os.environ.get('ADMIN_TOKEN')
config['DEFAULT']['rabbit_password'] = os.environ.get('ADMIN_TOKEN')
config['DEFAULT']['rabbit_virtual_host'] = os.environ.get('ADMIN_TOKEN')
config['DEFAULT']['notification_driver'] = os.environ.get('ADMIN_TOKEN')

config['database']['backend'] = 'sqlalchemy'
config['database']['connection'] = 'mysql://murano:%s@%s/murano' % (os.environ.get('MURANO_DBPASS'),
                                                                        os.environ.get('HOST_IP'))

config['keystone']['auth_url'] = 'http://%OPENSTACK_HOST_IP%:5000/v2.0'

config['keystone_authtoken']['auth_uri'] = 'http://%OPENSTACK_HOST_IP%:5000/v2.0'
config['keystone_authtoken']['auth_host'] = '%OPENSTACK_HOST_IP%'
config['keystone_authtoken']['auth_port'] = 5000
config['keystone_authtoken']['auth_protocol'] = http
config['keystone_authtoken']['admin_tenant_name'] = %OPENSTACK_ADMIN_TENANT%
config['keystone_authtoken']['admin_user'] = %OPENSTACK_ADMIN_USER%
config['keystone_authtoken']['admin_password'] = %OPENSTACK_ADMIN_PASSWORD%

config['murano']['url'] = 'http://%YOUR_HOST_IP%:8082'


config['rabbitmq']['host'] = %RABBITMQ_SERVER_IP%
config['rabbitmq']['login'] = %RABBITMQ_USER%
config['rabbitmq']['password'] = %RABBITMQ_PASSWORD%
config['rabbitmq']['virtual_host'] = %RABBITMQ_SERVER_VIRTUAL_HOST%

print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')