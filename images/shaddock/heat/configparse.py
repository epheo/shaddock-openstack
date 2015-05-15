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

keystone_host_ip = os.environ.get('KEYSTONE_HOST_IP')
host_ip = os.environ.get('HOST_IP')
mysql_host_ip = os.environ.get('MYSQL_HOST_IP')
rabbit_host_ip = os.environ.get('RABBIT_HOST_IP')
rabbit_pass = os.environ.get('RABBIT_PASS')
heat_pass = os.environ.get('HEAT_PASS')
heat_dbpass = os.environ.get('HEAT_DBPASS')
heat_domain_pass = os.environ.get('HEAT_DOMAIN_PASS')

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
     'my_ip': nova_host_ip,
     'auth_strategy': 'keystone',
     'verbose': 'True',
     'rabbit_host': rabbit_host_ip,
     'rabbit_password': rabbit_pass,
     'heat_metadata_server_url': 'http://%s:8000' % host_ip,
     'heat_waitcondition_server_url': 'http://%s:8000/v1/waitcondition' % host_ip,
     'stack_domain_admin': 'heat_domain_admin',
     'stack_domain_admin_password': heat_domain_pass,
     'stack_user_domain_name': 'heat_user_domain'},

    'database':
    {'connection':
     'mysql://heat:%s@%s/heat' % (heat_dbpass, mysql_host_ip)},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000/v2.0' % keystone_host_ip,
     'identity_uri': 'http://%s:35357' % keystone_host_ip,
     'admin_tenant_name': 'service',
     'admin_user': 'heat',
     'admin_password': heat_pass},

    'oslo_concurrency':
    {'lock_path': '/var/lock/heat'},

    'ec2authtoken':
    {'auth_uri': 'http://%s:5000/v2.0' % keystone_host_ip},

    }



apply_config('/etc/heat/heat.conf', heat_conf)
