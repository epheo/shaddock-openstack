#!/usr/bin/env python

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

import os
from setuptools import setup

def dirwalk(dir, giveDirs=0):
    for f in os.listdir(dir):
        fullpath = os.path.join(dir,f)
        if os.path.isdir(fullpath) and not os.path.islink(fullpath):
            if not len(os.listdir(fullpath)):
                yield fullpath + os.sep
            else:
                for x in dirwalk(fullpath):  # recurse into subdir
                    if os.path.isdir(x):
                        if giveDirs:
                            yield x
                    else:
                        yield x
        else:
            yield fullpath

def make_data_files():
    directories = ('openstack', 'conf')
    basedir = '/var/lib/panama/'
    data_files = []
    for directory in directories:
        files = dirwalk(directory)
        for file in files:
            data_files.append((basedir + os.path.dirname(file), [file]))
    return data_files

setup(
    name='panama-template',
    description='Easily deploy an OpenStack platform in Docker Containers',
    author='Thibaut Lapierre',
    author_email='root@epheo.eu',
    url='https://github.com/Epheo/panama-template',
    #long_description_markdown_filename='README.md',
    license='Apache Software License',
    version='0.0.5',
    data_files=make_data_files(),
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Environment :: Console',
        'Environment :: OpenStack',
        'Intended Audience :: Information Technology',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.3',
    ],
)
