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

nova_db_pass = os.environ.get('NOVA_DBPASS')
mysql_host_ip = os.environ.get('MYSQL_HOST_IP')
rabbit_host_ip = os.environ.get('RABBIT_HOST_IP')
rabbit_pass = os.environ.get('RABBIT_PASS')
nova_host_ip = os.environ.get('NOVA_HOST_IP')
keystone_host_ip = os.environ.get('KEYSTONE_HOST_IP')
nova_pass = os.environ.get('NOVA_PASS')
host_ip = os.environ.get('HOST_IP')
qemu = os.environ.get('QEMU')
nova_network = os.environ.get('NOVA_NETWORK')


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


nova_conf = {
    'DEFAULT':
    {'rpc_backend': 'rabbit',
     'auth_strategy': 'keystone',
     'my_ip': nova_host_ip,
     'vncserver_listen': '0.0.0.0',
     'vncserver_proxyclient_address': nova_host_ip,
     'verbose': 'True',
     'vnc_enabled': 'True',
     'novncproxy_base_url': 'http://%s:6080/vnc_auto.html' % host_ip},

     'oslo_messaging_rabbit':
     {'rabbit_host': rabbit_host_ip,
      'rabbit_password': rabbit_pass},

    'database':
    {'connection':
     'mysql://nova:%s@%s/nova' % (nova_db_pass, mysql_host_ip)},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000' % keystone_host_ip,
     'auth_url': 'http://%s:35357' % keystone_host_ip,
     'auth_plugin': 'password',
     'project_domain_id': 'default',
     'user_domain_id': 'default',
     'project_name': 'service',
     'username': 'nova',
     'password': nova_pass},

    'glance':
    {'host': host_ip},

    'oslo_concurrency':
    {'lock_path': '/var/lock/nova'},

    'libvirt':
    {'virt_type': 'qemu'}

    }

nova_conf_qemu = {
    'DEFAULT':
    {'compute_driver': 'libvirt.LibvirtDriver'}
    }

nova_conf_nova_network = {
    'DEFAULT':
    {'network_api_class': 'nova.network.api.API',
     'security_group_api': 'nova',
     'firewall_driver': 'nova.virt.libvirt.firewall.IptablesFirewallDriver',
     'network_manager': 'nova.network.manager.FlatDHCPManager',
     'network_size': '254',
     'allow_same_net_traffic': 'False',
     'multi_host': 'True',
     'send_arp_for_ha': 'True',
     'share_dhcp_address': 'True',
     'force_dhcp_release': 'True',
     'flat_network_bridge': 'br100',
     'flat_interface': 'eth0',
     'public_interface': 'eth0'},
    }

nova_compute_conf = {
    'DEFAULT':
    {'compute_driver': 'libvirt.LibvirtDriver'},

    'libvirt':
    {'virt_type': 'qemu'}

    }

apply_config('/etc/nova/nova.conf', nova_conf)

if qemu is True:
    apply_config('/etc/nova/nova.conf', nova_conf_qemu)

if nova_network is True:
    apply_config('/etc/nova/nova.conf', nova_conf_nova_network)

apply_config('/etc/nova/nova-compute.conf', nova_compute_conf)
