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


def apply_config(configfile, dict):
    config = ConfigParser.RawConfigParser()
    config.read(configfile)

    for section in dict.keys():
        if not set([section]).issubset(
                config.sections()) and section != 'DEFAULT':
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


nova_conf = {
    'DEFAULT':
    {'enabled_apis': 'osapi_compute,metadata',
     'auth_strategy': 'keystone',
     'my_ip': os.environ.get('NOVA_API_IP'),
     'use_neutron': 'False',
     'network_api_class': 'nova.network.api.API',
     'security_group_api': 'nova',
     '#firewall_driver': 'nova.virt.firewall.NoopFirewallDriver',
     'transport_url': 'rabbit://guest:{}@{}/'.format(
         os.environ.get('RABBIT_PASS'),
         os.environ.get('RABBIT_HOST_IP')
         )
     },

    'api_database':
    {'connection': 'mysql://nova:{}@{}/nova_api'.format(
        os.environ.get('NOVA_DBPASS'),
        os.environ.get('MYSQL_HOST_IP'))
     },

    'database':
    {'connection': 'mysql://nova:{}@{}/nova'.format(
        os.environ.get('NOVA_DBPASS'),
        os.environ.get('MYSQL_HOST_IP'))
     },

    'keystone_authtoken':
    {'auth_uri': 'http://{}:5000'.format(os.environ.get('KEYSTONE_API_IP')),
     'auth_url': 'http://{}:35357'.format(os.environ.get('KEYSTONE_API_IP')),
     'memcached_servers': '{}:11211'.format(os.environ.get('KEYSTONE_API_IP')),
     'auth_type': 'password',
     'project_domain_name': 'default',
     'user_domain_name': 'default',
     'project_name': 'service',
     'username': 'nova',
     'password': os.environ.get('NOVA_PASS')
     },

    'oslo_concurrency':
    {'lock_path': '/var/lib/nova/tmp'

     },

    'vnc':
    {'vncserver_listen': os.environ.get('NOVA_API_IP'),
     'vncserver_proxyclient_address': os.environ.get('NOVA_API_IP')

     },

    'glance':
    {'api_servers': 'http://{}:9292'.format(os.environ.get('GLANCE_API_IP'))},

    'neutron':
    {'#url': 'http://{}:9696'.format(os.environ.get('NEUTRON_API_IP')),
     '#auth_url': 'http://{}:35357'.format(os.environ.get('KEYSTONE_API_IP')),
     '#auth_type': 'password',
     '#project_domain_name': 'default',
     '#user_domain_name': 'default',
     '#region_name': 'RegionOne',
     '#project_name': 'service',
     '#username': 'neutron',
     '#password': 'panama',
     '#service_metadata_proxy': 'True',
     '#metadata_proxy_shared_secret': 'panama'
     },

    'cinder':
    {'os_region_name': 'RegionOne'},

}

apply_config('/etc/nova/nova.conf', nova_conf)
