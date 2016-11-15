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
rabbit_host_ip = os.environ.get('RABBIT_HOST_IP')
rabbit_pass = os.environ.get('RABBIT_PASS')
manila_host_ip = os.environ.get('MANILA_HOST_IP')
manila_pass = os.environ.get('MANILA_PASS')
manila_db_pass = os.environ.get('MANILA_DBPASS')


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

manila_conf = {
    'DEFAULT':
    {'rpc_backend': 'rabbit',
     'default_share_type': 'default_share_type',
     'rootwrap_config': '/etc/manila/rootwrap.conf',
     'enabled_share_backends': 'lvm',
     'enabled_share_protocols': 'NFS,CIFS',
     'auth_strategy': 'keystone',
     'my_ip': manila_host_ip},

    'oslo_messaging_rabbit':
    {'rabbit_host': rabbit_host_ip,
     'rabbit_password': rabbit_pass},

    'database':
    {'connection':
     'mysql://manila:%s@%s/manila' % (manila_db_pass, mysql_host_ip)},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000' % keystone_host_ip,
     'auth_url': 'http://%s:35357' % keystone_host_ip,
     'memcached_servers': '%s:11211' % keystone_host_ip,
     'auth_type': 'password',
     'project_domain_name': 'default',
     'user_domain_name': 'default',
     'project_name': 'service',
     'username': 'manila',
     'password': manila_pass},

    'oslo_concurrency':
    {'lock_path': '/var/lib/manila/tmp'},

    'lvm':
    {'share_backend_name': 'LVM',
     'share_driver': 'manila.share.drivers.lvm.LVMShareDriver',
     'driver_handles_share_servers': 'False',
     'lvm_share_volume_group': 'manila-volumes',
     'lvm_share_export_ip': manila_host_ip},

    }

apply_config('/etc/manila/manila.conf', manila_conf)

