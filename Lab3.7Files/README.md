# **3.7. Компьютерные сети, лекция 2**

# *1. Cписок доступных сетевых интерфейсов.*
Для просмотра сетевых интерфейсов используются команды 'ipconfig' (Windows), 'ifconfig' (Linux). Вместо 'ifconfig' в Linux сейчас используется команда 'ip': 

```
ip -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp5s0           DOWN           f0:bf:97:12:1c:a8 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
wlp2s0           UP             64:80:99:03:aa:c0 <BROADCAST,MULTICAST,UP,LOWER_UP> 
enx001de142ce2e  DOWN           00:1d:e1:42:ce:2e <NOARP> 
vboxnet0         DOWN           0a:00:27:00:00:00 <BROADCAST,MULTICAST> 
vboxnet1         DOWN           0a:00:27:00:00:01 <NO-CARRIER,BROADCAST,MULTICAST,UP>
``` 

# *2. Протокол для распознавания соседа по сетевому интерфейсу*

В Linux используется протокол LLDP (Link Layer Discovery Protocol) для обмена информацией о соседних устройствах. Для использования этого протокола нужно установить пакет 'lldpd'. Просмотреть информацию о соседних устройствах можно командой 'lldpctl'.

# *3. Виртуальные сети*

Для разделения L2 коммутатора на несколько виртуальных сетей используется технология VLAN (Virtual Local Area Network). Для использования данной технологии в Linux нужно установить пакет 'vlan'. Управление осуществляется командой 'vconfig'. Чтобы информация о созданных VLAN сохранилась после перезагрузки, настройки необходимо добавить в файл '/etc/network/interfaces'. Пример конфига:

```
auto eth0.1400
iface eth0.1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
```

# *4. Типы агрегации интерфейсов в Linux*

В Linux используется LAG (link aggregation) для агрегации каналов. Для использования данной технологии нужно установить пакет 'ifenslave'. Для балансировки нагрузки использеутся опция 'bond-mode', которая может принимать значения:

```
balance-rr
active-backup
balance-xor
broadcast
802.3ad
balance-tlb
balance-alb
```

Пример конфига, файл '/etc/network/interfaces':

```
# Define slaves   
auto eth0
iface eth0 inet manual
    bond-master bond0
    bond-primary eth0
    bond-mode active-backup
   
auto wlan0
iface wlan0 inet manual
    wpa-conf /etc/network/wpa.conf
    bond-master bond0
    bond-primary eth0
    bond-mode active-backup

# Define master
auto bond0
iface bond0 inet dhcp
    bond-slaves none
    bond-primary eth0
    bond-mode active-backup
    bond-miimon 100
```

# *5. IP адреса*
В сети с маской /29 можно назначить IP адреса 6-ти хостам. Из сети с маской /24 можно получить 32 сети с маской /29.

```
 1.
Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
Hosts/Net: 6                     Class A, Private Internet

 2.
Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
HostMin:   10.10.10.9           00001010.00001010.00001010.00001 001
HostMax:   10.10.10.14          00001010.00001010.00001010.00001 110
Broadcast: 10.10.10.15          00001010.00001010.00001010.00001 111
Hosts/Net: 6                     Class A, Private Internet

 3.
Network:   10.10.10.16/29       00001010.00001010.00001010.00010 000
HostMin:   10.10.10.17          00001010.00001010.00001010.00010 001
HostMax:   10.10.10.22          00001010.00001010.00001010.00010 110
Broadcast: 10.10.10.23          00001010.00001010.00001010.00010 111
Hosts/Net: 6                     Class A, Private Internet
....
....

Subnets:   32
Hosts:     192
```

# *6. Частные IP адреса*

Частные IP адреса допустимо взять из сети 100.64.0.0/10 (Carrier-Grade NAT)

Для 40-50 хостов внутри подсети подойдёт маска /26:

```
1. Requested size: 60 hosts
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
Hosts/Net: 62
```

Что в результате даст 62 хоста в подсети. Маска /27 не подойдёт, т.к. в этом случае получаем подсеть для 30-ти хостов.

# *7. ARP таблица*
Просмотреть ARP таблицу можно командой 'arp -a' в Windows и 'ip neigh' в Linux.

Очистить весь ARP кеш можно командой 'arp -d' в Windows и 'sudo ip neigh flush all' в Linux

Один IP можно удалить из ARP таблицы командами 'arp -d IP' в Windows и 'sudo ip neigh flush IP' в Linux