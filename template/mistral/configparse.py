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

configfile = '/mistral/etc/mistral.conf.sample'
config = ConfigParser.RawConfigParser()
config.read(configfile)

section = 'DEFAULT'
config.set(section, 'rpc_backend', 'rabbit')
config.set(section, 'rabbit_host', os.environ.get('HOST_IP'))
config.set(section, 'rabbit_password', os.environ.get('RABBIT_PASS'))

section = 'database'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'connection',
                    'mysql://mistral:%s@%s/mistral' 
                    % (os.environ.get('MISTRAL_DBPASS'),
                       os.environ.get('HOST_IP')))

section = 'keystone_authtoken'
if not set([section]).issubset(config.sections()):
    config.add_section(section)
config.set(section, 'auth_uri', 
                    'http://%s:5000/v3' % os.environ.get('HOST_IP'))
config.set(section, 'identity_uri', 
                    'http://%s:35357' % os.environ.get('HOST_IP'))
config.set(section, 'admin_tenant_name', 'service')
config.set(section, 'auth_version', 'v3')
config.set(section, 'admin_user', 'mistral')
config.set(section, 'admin_password', os.environ.get('MISTRAL_PASS'))

configfile = '/mistral/etc/mistral.conf'
print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')
