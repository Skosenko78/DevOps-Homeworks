#!/usr/bin/env bash

# Cкрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту
# и записывает результат в файл log. Доступность проверяется пять раз для каждого узла.

ip_array=(192.168.0.1 173.194.222.113 87.250.250.242)

for i in {1..5}
do
    echo "Turn $i"
    date >> av_host.log
    for host_ip in ${ip_array[@]}
    do
        curl -s --connect-timeout 3 http://$host_ip > /dev/null
        if [ $? == 0 ]
        then
            echo "HTTP service on $host_ip is available" >> av_host.log
        else
            echo "HTTP service on $host_ip is unavailable" >> av_host.log
        fi
    done
done