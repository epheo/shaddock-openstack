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

keystone_db_pass = os.environ.get('KEYSTONE_DB_PASS')
mysql_host_ip = os.environ.get('MYSQL_HOST_IP')
admin_token = os.environ.get('ADMIN_TOKEN')

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

keystone_conf = {
            'DEFAULT':
            {'admin_token': admin_token,
             'verbose': 'True'},

            'database':
            {'connection':
             'mysql://keystone:%s@%s/keystone' % (keystone_db_pass, mysql_host_ip)},


configfile = '/opt/keystone/etc/keystone.conf.sample'
config = ConfigParser()
config.read(configfile)

config['DEFAULT']['admin_token'] = os.environ.get('ADMIN_TOKEN')

config['database']['connection'] = 'mysql://keystone:%s@%s/keystone' % (os.environ.get('KEYSTONE_DBPASS'),
                                                                        os.environ.get('MYSQL_HOST_IP'))

config['token']['provider'] = 'keystone.token.providers.uuid.Provider'
config['token']['driver'] = 'keystone.token.persistence.backends.sql.Token'
config['revoke']['driver'] = 'keystone.contrib.revoke.backends.sql.Revoke'
config['DEFAULT']['verbose'] = 'True'

configfile = '/opt/keystone/etc/keystone.conf'
print('Parsing of %s...' % configfile)
with open(configfile, 'w') as configfile:
    config.write(configfile)
print('Done')