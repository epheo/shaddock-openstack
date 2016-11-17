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
keystone_host_ip = os.environ.get('KEYSTONE_API_IP')
rabbit_host_ip = os.environ.get('RABBIT_HOST_IP')
rabbit_pass = os.environ.get('RABBIT_PASS')
heat_host_ip = os.environ.get('HEAT_HOST_IP')
heat_pass = os.environ.get('HEAT_PASS')
heat_db_pass = os.environ.get('HEAT_DBPASS')


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

heat_conf = {
    'DEFAULT':
    {'rpc_backend': 'rabbit',
     'heat_metadata_server_url': 'http://%s:8000' % heat_host_ip,
     'heat_waitcondition_server_url': 'http://%s:8000/v1/waitcondition' % heat_host_ip,
     'stack_domain_admin': 'heat_domain_admin',
     'stack_domain_admin_password': heat_pass,
     'stack_user_domain_name': 'heat'},

    'oslo_messaging_rabbit':
    {'rabbit_host': rabbit_host_ip,
     'rabbit_password': rabbit_pass},

    'database':
    {'connection':
     'mysql://heat:%s@%s/heat' % (heat_db_pass, mysql_host_ip)},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000' % keystone_host_ip,
     'auth_url': 'http://%s:35357' % keystone_host_ip,
     'memcached_servers': '%s:11211' % keystone_host_ip,
     'auth_type': 'password',
     'project_domain_name': 'default',
     'user_domain_name': 'default',
     'project_name': 'service',
     'username': 'heat',
     'password': heat_pass},

    'trustee':
    {'auth_plugin': 'password',
     'auth_url': 'http://%s:35357' % keystone_host_ip,
     'username': 'heat',
     'password': heat_pass,
     'user_domain_name': 'default'},

    'clients_keystone':
    {'auth_uri': 'http://%s:35357' % keystone_host_ip},

    'ec2authtoken':
    {'auth_uri': 'http://%s:5000' % keystone_host_ip},

    }

apply_config('/etc/heat/heat.conf', heat_conf)

