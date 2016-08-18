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
nova_host_ip = os.environ.get('NOVA_HOST_IP')
nova_pass = os.environ.get('NOVA_PASS')
neutron_pass = os.environ.get('NEUTRON_PASS')

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


neutron_conf = {
    'DEFAULT':
    {'core_plugin': 'ml2',
     'service_plugins': 'router',
     'allow_overlapping_ips': 'True',
     'auth_strategy': 'keystone',
     'notify_nova_on_port_status_changes': 'True',
     'notify_nova_on_port_data_changes': 'True',
     'rpc_backend': 'rabbit'},

    'oslo_messaging_rabbit':
    {'rabbit_host': os.environ.get('RABBIT_HOST_IP'),
     'rabbit_password': os.environ.get('RABBIT_PASS')},

    'database':
    {'connection':
     'mysql://neutron:%s@%s/neutron' % (os.environ.get('NEUTRON_DBPASS'), os.environ.get('MYSQL_HOST_IP'))},

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

    'nova':
    {'auth_url': 'http://%s:35357' % nova_host_ip,
     'auth_type': 'password',
     'project_domain_name': 'default',
     'user_domain_name': 'default',
     'region_name': 'RegionOne',
     'project_name': 'service',
     'username': 'nova',
     'password': nova_pass},

    }

apply_config('/etc/neutron/neutron.conf', neutron_conf)


neutron_ml2_conf = {
    'ml2':
    {'type_drivers': 'flat,vlan,vxlan',
     'tenant_network_types': 'vxlan',
     'mechanism_drivers': 'linuxbridge,l2population',
     'extension_drivers': 'port_security'},

    'ml2_type_flat':
    {'flat_networks': 'provider'},

    'ml2_type_vxlan':
    {'vni_ranges': '1:1000'},

    'securitygroup':
    {'enable_ipset': 'True'},
    }

apply_config('/etc/neutron/plugins/ml2/ml2_conf.ini', neutron_ml2_conf)


neutron_linuxbridge_agent_conf = {
    'linux_bridge':
    {'physical_interface_mappings': 'provider:eth0'},

    'vxlan':
    {'enable_vxlan': 'True',
     'local_ip':  os.popen('ifconfig eth0 | grep "inet\ adr" | cut -d: -f2 | cut -d" " -f1').read().rstrip(),
     'l2_population': 'True'},

    'securitygroup':
    {'enable_security_group': 'True',
     'firewall_driver': 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver'},
    }

apply_config('/etc/neutron/plugins/ml2/linuxbridge_agent.ini', neutron_linuxbridge_agent_conf)


neutron_l3_agent_conf = {
    'DEFAULT':
    {'interface_driver': 'neutron.agent.linux.interface.BridgeInterfaceDriver',
     'external_network_bridge': ''},
    }

apply_config('/etc/neutron/l3_agent.ini', neutron_l3_agent_conf)


neutron_dhcp_agent_conf = {
    'DEFAULT':
    {'interface_driver': 'neutron.agent.linux.interface.BridgeInterfaceDriver',
     'dhcp_driver': 'neutron.agent.linux.dhcp.Dnsmasq',
     'enable_isolated_metadata': 'True'},
    }

apply_config('/etc/neutron/dhcp_agent.ini', neutron_l3_agent_conf)


neutron_metadata_agent_conf = {
    'DEFAULT':
    {'nova_metadata_ip': os.environ.get('HOST_IP'),
     'metadata_proxy_shared_secret': os.environ.get('NEUTRON_PASS')},
    }

apply_config('/etc/neutron/metadata_agent.ini', neutron_metadata_agent_conf)
