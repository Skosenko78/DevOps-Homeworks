#!/usr/bin/env python3

import os

bash_command = ["cd ~/test", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result =  os.getcwd() + '/' + result.replace('\tизменено:      ', '')
        print(prepare_result)
