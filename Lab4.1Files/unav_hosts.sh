#!/usr/bin/env bash

#Скрипт выполняется до тех пор, пока один из узлов не окажется недоступным.
#Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

ip_array=(173.194.222.113 87.250.250.242 192.168.0.1)

while ((1==1))
do
    for host_ip in ${ip_array[@]}
    do
        if ( ! curl -s --connect-timeout 3 http://$host_ip > /dev/null )
        then
            echo "$(date): $host_ip service is unavailable" > error
            break 2
        fi
    done
done