#!/usr/bin/env python3

import socket

hosts_dict = {'drive.google.com':'','mail.google.com':'','google.com':''}

for keys in hosts_dict:
    hosts_dict[keys] = socket.gethostbyname(keys)

while True:
    for keys in hosts_dict:
        current_IP = socket.gethostbyname(keys)
        if current_IP !=  hosts_dict[keys]:
            print ('[ERROR] {} IP mismatch: {} {}'.format(keys, hosts_dict[keys], current_IP))
            hosts_dict[keys] = current_IP