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

keystone_host_ip = os.environ.get('KEYSTONE_API_IP')
rabbit_host_ip = os.environ.get('RABBIT_HOST_IP')
rabbit_pass = os.environ.get('RABBIT_PASS')
glance_host_ip = os.environ.get('GLANCE_API_IP')
neutron_host_ip = os.environ.get('NEUTRON_API_IP')
neutron_pass = os.environ.get('NEUTRON_PASS')
nova_host_ip = os.environ.get('NOVA_API_IP')
nova_db_pass = os.environ.get('NOVA_DBPASS')
nova_pass = os.environ.get('NOVA_PASS')


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
     'use_neutron': 'False',
     'firewall_driver': 'nova.virt.firewall.NoopFirewallDriver',
     'network_api_class': 'nova.network.api.API',
     'security_group_api': 'nova',
     'network_manager': 'nova.network.manager.FlatDHCPManager',
     'network_size': '254',
     'allow_same_net_traffic': 'False',
     'multi_host': 'True',
     'send_arp_for_ha': 'True',
     'share_dhcp_address': 'True',
     'force_dhcp_release': 'True',
     'flat_network_bridge': 'br100',
     'flat_interface': 'eth0',
     'public_interface': 'eth0',
     'verbose': 'True'},

    'oslo_messaging_rabbit':
    {'rabbit_host': rabbit_host_ip,
     'rabbit_password': rabbit_pass},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000' % keystone_host_ip,
     'auth_url': 'http://%s:35357' % keystone_host_ip,
     'memcached_servers': '%s:11211' % keystone_host_ip,
     'auth_type': 'password',
     'project_domain_name': 'default',
     'user_domain_name': 'default',
     'project_name': 'service',
     'username': 'nova',
     'password': nova_pass},

    'oslo_concurrency':
    {'lock_path': '/var/lib/nova/tmp'},

    'vnc':
    {'enabled': 'True',
     'vncserver_listen': '0.0.0.0',
     'vncserver_proxyclient_address': nova_host_ip,
     'novncproxy_base_url': 'http://%s:6080/vnc_auto.html' % nova_host_ip},

    'glance':
    {'api_servers': 'http://%s:9292' % glance_host_ip},

    '#neutron':
    {'#url': 'http://%s:9696' % neutron_host_ip,
     '#auth_url': 'http://%s:35357' % keystone_host_ip,
     '#auth_type': 'password',
     '#project_domain_name': 'default',
     '#user_domain_name': 'default',
     '#region_name': 'RegionOne',
     '#project_name': 'service',
     '#username': 'neutron',
     '#password': neutron_pass,
     '#service_metadata_proxy': 'True',
     '#metadata_proxy_shared_secret': neutron_pass},

    }

nova_compute_conf = {
    'DEFAULT':
    {'compute_driver': 'libvirt.LibvirtDriver'},

    'libvirt':
    {'virt_type': 'qemu'}

}

apply_config('/etc/nova/nova.conf', nova_conf)
apply_config('/etc/nova/nova-compute.conf', nova_compute_conf)

neutron_conf = {
    'DEFAULT':
    {'auth_strategy': 'keystone',
     'rpc_backend': 'rabbit',
     'debug': 'True',
     'verbose': 'True'},

    'oslo_messaging_rabbit':
    {'rabbit_host': os.environ.get('RABBIT_HOST_IP'),
     'rabbit_password': os.environ.get('RABBIT_PASS')},

    'keystone_authtoken':
    {'auth_uri': 'http://%s:5000' % keystone_host_ip,
     'auth_url': 'http://%s:35357' % keystone_host_ip,
     'memcached_servers': '%s:11211' % keystone_host_ip,
     'auth_type': 'password',
     'project_domain_name': 'default',
     'user_domain_name': 'default',
     'project_name': 'service',
     'username': 'neutron',
     'password': neutron_pass},

    }

# apply_config('/etc/neutron/neutron.conf', neutron_conf)


neutron_linuxbridge_agent_conf = {
    'linux_bridge':
    {'physical_interface_mappings': 'provider:eth0'},

    'vxlan':
    {'enable_vxlan': 'False'},

    'securitygroup':
    {'enable_security_group': 'True',
     'firewall_driver': 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver'},
    }

# apply_config('/etc/neutron/plugins/ml2/linuxbridge_agent.ini',
#              neutron_linuxbridge_agent_conf)
