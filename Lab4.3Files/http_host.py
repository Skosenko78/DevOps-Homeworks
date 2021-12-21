#!/usr/bin/env python3

import socket
import json
import yaml

hosts_dict = {'drive.google.com':'','mail.google.com':'','google.com':''}

for keys in hosts_dict:
  hosts_dict[keys] = socket.gethostbyname(keys)
  fjson = open ('http_hosts.json', 'w')
  fjson.write(json.dumps(hosts_dict))
  fjson.close()
  fyaml = open ('http_hosts.yml', 'w')
  fyaml.write(yaml.dump(hosts_dict, indent=3))
  fyaml.close()

while True:
  for keys in hosts_dict:
    current_IP = socket.gethostbyname(keys)
    if current_IP !=  hosts_dict[keys]:
      print ('[ERROR] {} IP mismatch: {} {}'.format(keys, hosts_dict[keys], current_IP))
      hosts_dict[keys] = current_IP
      with open ('http_hosts.json', 'w') as fjson:
        fjson.write(json.dumps(hosts_dict))
      with open ('http_hosts.yml', 'w') as fyaml:
        fyaml.write(yaml.dump(hosts_dict, indent=3))