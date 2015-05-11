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

import ConfigParser
import os

mysql_host_ip = os.environ.get('MYSQL_HOST_IP')
keystone_host_ip = os.environ.get('KEYSTONE_HOST_IP')
glance_pass = os.environ.get('GLANCE_PASS')
glance_db_pass = os.environ.get('GLANCE_DB_PASS')


def apply_config(configfile, dict):
    config = ConfigParser.RawConfigParser()
    config.read(configfile)

    for section in dict.keys():
        if not set([section]).issubset(config.sections()) \
                and section != 'DEFAULT':
            config.add_section(section)
        inner_dict = dict.get(section)
        for key in inner_dict.keys():
            config.set(section, key, inner_dict.get(key))
            print('Writing %s : %s in section %s of the file %s'
                  % (key,
                     inner_dict.get(key),
                     section,
                     configfile))

    with open(configfile, 'w') as configfile:
        config.write(configfile)
    print('Done')
    return True

glance_api_conf = {
    'DEFAULT':
    {'notification_driver': 'noop',
     'verbose': 'True'},

    'database':
    {'connection':
     'mysql://glance:%s@%s/glance' % (glance_db_pass, mysql_host_ip)},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000/v2.0' % keystone_host_ip,
     'identity_uri': 'http://%s:35357' % keystone_host_ip,
     'admin_tenant_name': 'service',
     'admin_user': 'glance',
     'admin_password': glance_pass},

    'paste_deploy':
    {'flavor': 'keystone'},

    'glance_store':
    {'default_store': 'file',
     'filesystem_store_datadir': '/var/lib/glance/images/'}
    }

glance_registry_conf = {
    'DEFAULT':
    {'notification_driver': 'noop',
     'verbose': 'True'},

    'database':
    {'connection':
     'mysql://glance:%s@%s/glance' % (glance_db_pass, mysql_host_ip)},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000/v2.0' % keystone_host_ip,
     'identity_uri': 'http://%s:35357' % keystone_host_ip,
     'admin_tenant_name': 'service',
     'admin_user': 'glance',
     'admin_password': glance_pass},

    'paste_deploy':
    {'flavor': 'keystone'},

    }

apply_config('/etc/glance/glance-api.conf', glance_api_conf)
apply_config('/etc/glance/glance-registry.conf', glance_registry_conf)