#!/usr/bin/python2
import os
import ast

CONFIGURE_ARRAY = ast.literal_eval(os.environ.get('CONFIGURE_LIST'))

for config in CONFIGURE_ARRAY:
  os.system('create-%s.sh' % config)
