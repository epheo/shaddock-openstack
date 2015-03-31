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

    
## nova.conf
############

configfile = '/etc/nova/nova.conf'
config = ConfigParser.RawConfigParser()
config.read(configfile)

section = 'database'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'connection',  'mysql://nova:%s@%s/nova' % (os.environ.get('NOVA_DBPASS'),
                                                                os.environ.get('HOST_IP')))

section = 'DEFAULT'
#if not set([section]).issubset(config.sections()):
#    config.add_section(section)
config.set(section, 'rpc_backend', 'rabbit')
config.set(section, 'rabbit_host', os.environ.get('HOST_IP'))
config.set(section, 'rabbit_password', os.environ.get('RABBIT_PASS'))
config.set(section, 'auth_strategy', 'keystone')
config.set(section, 'my_ip', os.environ.get('HOST_IP'))
config.set(section, 'vncserver_listen', os.environ.get('HOST_IP'))
config.set(section, 'vncserver_proxyclient_address', os.environ.get('HOST_IP'))
config.set(section, 'verbose', 'True')

section = 'keystone_authtoken'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'auth_uri', 'http://%s:5000/v2.0' % os.environ.get('HOST_IP'))
config.set(section, 'identity_uri', 'http://%s:35357' % os.environ.get('HOST_IP'))
config.set(section, 'admin_tenant_name', 'service')
config.set(section, 'admin_user', 'nova')
config.set(section, 'admin_password', os.environ.get('NOVA_PASS'))

section = 'glance'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'host', os.environ.get('HOST_IP'))

print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')


## neutron.conf
###############

configfile = '/etc/neutron/neutron.conf'
config.read(configfile)

section = 'database'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'connection', 'mysql://neutron:%s@%s/neutron' % (os.environ.get('NEUTRON_DBPASS'),
                                                                     os.environ.get('HOST_IP')))

section = 'DEFAULT'
#if not set([section]).issubset(config.sections()):
#    config.add_section(section)
config.set(section, 'rpc_backend', 'rabbit')
config.set(section, 'rabbit_host', os.environ.get('HOST_IP'))
config.set(section, 'rabbit_password', os.environ.get('RABBIT_PASS'))
config.set(section, 'auth_strategy', 'keystone')
config.set(section, 'core_plugin', 'ml2')
config.set(section, 'service_plugins', 'router')
config.set(section, 'allow_overlapping_ips', 'True')
config.set(section, 'notify_nova_on_port_status_changes', 'True')
config.set(section, 'notify_nova_on_port_data_changes', 'True')
config.set(section, 'nova_url', 'http://%s:8774/v2' % os.environ.get('HOST_IP'))
config.set(section, 'nova_admin_auth_url', 'http://%s:35357/v2' % os.environ.get('HOST_IP'))
config.set(section, 'nova_region_name', 'regionOne')
config.set(section, 'nova_admin_username', 'nova')
config.set(section, 'nova_admin_tenant_id', 'service')
config.set(section, 'nova_admin_password', os.environ.get('NOVA_PASS'))
config.set(section, 'verbose', 'True')

section = 'keystone_authtoken'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'auth_uri', 'http://%s:5000/v2.0' % os.environ.get('HOST_IP'))
config.set(section, 'identity_uri', 'http://%s:35357' % os.environ.get('HOST_IP'))
config.set(section, 'admin_tenant_name', 'service')
config.set(section, 'admin_user', 'neutron')
config.set(section, 'admin_password', os.environ.get('NEUTRON_PASS'))

print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')


## ml2_conf.ini
###############

configfile = '/etc/neutron/plugins/ml2/ml2_conf.ini'
config.read(configfile)

section = 'ml2'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'type_drivers', 'flat,gre')
config.set(section, 'tenant_network_types', 'gre')
config.set(section, 'mechanism_drivers', 'openvswitch')

section = 'ml2_type_gre'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'tunnel_id_ranges', '1:1000')

section = 'securitygroup'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'enable_security_group', 'True')
config.set(section, 'enable_ipset', 'True')
config.set(section, 'firewall_driver', 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver')

print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')


## nova.conf
############

configfile = '/etc/nova/nova.conf'
config.read(configfile)

section = 'DEFAULT'
#if not set([section]).issubset(config.sections()):
#    config.add_section(section)
config.set(section, 'network_api_class', 'nova.network.neutronv2.api.API')
config.set(section, 'security_group_api', 'neutron')
config.set(section, 'linuxnet_interface_driver', 'nova.network.linux_net.LinuxOVSInterfaceDriver')
config.set(section, 'firewall_driver', 'nova.virt.firewall.NoopFirewallDriver')

section = 'neutron'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'url', 'http://controller:9696')
config.set(section, 'auth_strategy', 'keystone')
config.set(section, 'admin_auth_url', 'http://controller:35357/v2.0')
config.set(section, 'admin_tenant_name', 'service')
config.set(section, 'admin_username',  section)
config.set(section, 'admin_password', os.environ.get('NEUTRON_PASS'))

print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')
