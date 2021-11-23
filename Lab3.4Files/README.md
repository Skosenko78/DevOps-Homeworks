# **3.4. Операционные системы, часть 2**

# *1. Node_exporter.*
Создан unit файл '/etc/systemd/system/node_exporter.service' следующего содержания:
 
```
[Unit]
Description=Prometheus exporter for machine metrics
After=network-online.target

[Service]
User=root
EnvironmentFile=/etc/node_exporter/node_exporter.conf
ExecStart=/usr/local/bin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
```

Также создадим файл конфигурации '/etc/node_exporter/node_exporter.conf', который пока содержит только:

```
OPTIONS=''
```

Перечитаем unit файлы, чтобы наш новый файл стал виден демону systemd:

```
sudo systemctl daemon-reload
```

И проверим запуск node_exporter в режиме демона:

```
vagrant@vagrant:~/node_exporter-1.3.0.linux-amd64$ sudo systemctl start node_exporter
vagrant@vagrant:~/node_exporter-1.3.0.linux-amd64$ sudo systemctl status node_exporter
● node_exporter.service - Prometheus exporter for machine metrics
     Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendor preset: enabled)
     Active: active (running) since Tue 2021-11-23 13:37:35 UTC; 3s ago
   Main PID: 13043 (node_exporter)
      Tasks: 3 (limit: 2279)
     Memory: 2.2M
     CGroup: /system.slice/node_exporter.service
             └─13043 /usr/local/bin/node_exporter

Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=thermal_zone
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=time
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=timex
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=udp_queues
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=uname
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=vmstat
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=xfs
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:115 level=info collector=zfs
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.111Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Nov 23 13:37:35 vagrant node_exporter[13043]: ts=2021-11-23T13:37:35.114Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
```

Сделаем автоматический запуск демона при загрузке:

```
agrant@vagrant:~/node_exporter-1.3.0.linux-amd64$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
```

После перезагрузки демон успешно запустился.

# *2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию.*
Опции 'node_exporter' посмотрим командой:

```
node_exporter --help
```
А метрики по-умолчанию можно увидеть так:

```
curl http://localhost:9100/metrics
```
Для базового мониторинга хоста по CPU, памяти, диску и сети я бы использовал опции:
```
--collector.cpu
--collector.meminfo
--collector.diskstats
--collector.netstat
```

# *3. Установите в свою виртуальную машину Netdata.*

```
sudo apt install -y netdata
```

Добавим секцию в файл '/etc/netdata/netdata.conf':

```
[web]
	bind to = 0.0.0.0
```

Сделаем проброс порта 19999 с локальной машины на гостевую:

```
config.vm.network "forwarded_port", guest: 19999, host: 19999
```

И перезапустим виртуальную машину.

После этого успешно открылась ссылка 'http://localhost:19999/' с локальной машины

С метриками и комментариями ознакомился.

# *4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?*
Можно, в dmesg есть строчка:

```
vagrant@vagrant:~$ dmesg | grep -i hyper
[    0.000000] Hypervisor detected: KVM
```

# *5. Как настроен sysctl fs.nr_open на системе по-умолчанию?*

```
vagrant@vagrant:~$ sudo sysctl -a | grep fs.nr.open
fs.nr_open = 1048576
```
nr_open - это максимальное количество файлов, которое может быть выделено одним процессом.

Установка ulimit -n	ЧИСЛО (the maximum number of open file descriptors) не позволит достичь значения fs.nr_open

# *6. Namespaces*
Запустим 'sleep 1h' в отдельном namespace:
```
root@vagrant:~# unshare -f --pid --mount-proc sleep 1h

```

В другой консоли попробуем подключиться к этому namespace. Узнаем pid этого процесса:

```
vagrant@vagrant:~$ ps -axf
...
   1486 pts/0    S+     0:00  |                   \_ unshare -f --pid --mount-proc sleep 1h
   1487 pts/0    S+     0:00  |                       \_ sleep 1h
...
```

И выполним команду:

```
root@vagrant:~# nsenter --target 1487 --mount --pid
root@vagrant:/# ps ax
    PID TTY      STAT   TIME COMMAND
      1 pts/0    S+     0:00 sleep 1h
     12 pts/1    S      0:00 -bash
     21 pts/1    R+     0:00 ps ax
root@vagrant:/# 
```
Мы подключились к namespace. В выводе команды 'ps' видно, что 'sleep' запущен с PID 1.

# *7. Запуск команды :(){ :|:& };: в виртуальной машине*
Эта команда определяет функцию с именем : , которая вызывает себя дважды (Код: : | : ). Это происходит в фоновом режиме ( & ). После ; определение функции выполнено, и функция : запускается.

Автоматической стабилизации помог механизм cgroups, это видно по сообщению в dmesg:

```
cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope
```

Лимиты данной настройки хранятся в файле:

```
cat /sys/fs/cgroup/pids/user.slice/user-1000.slice/pids.max
```
Лимит можно изменить поменяв значение в файле pid.max.

Предотвратить такие атаки можно используя ulimit для ограничения количества процессов на пользователя:

```
$ ulimit -u 50
```