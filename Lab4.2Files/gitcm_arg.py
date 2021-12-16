#!/usr/bin/env python3

import os
import sys

cd_dir = 'cd ' + sys.argv[1]

if sys.argv[1][-1] == '/':
    rep_dir = sys.argv[1]
else:
    rep_dir = sys.argv[1] + '/'

bash_command = [cd_dir, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result =  rep_dir + result.replace('\tизменено:      ', '')
        print(prepare_result)
