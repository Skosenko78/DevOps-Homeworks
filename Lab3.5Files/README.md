# **3.5. Файловые системы**

# *1. Узнайте о sparse (разряженных) файлах.*

Разряженный файл — файл, в котором последовательности нулевых байтов заменены на информацию об этих последовательностях.

# *2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца?*

Нет, не могут. Жесткие ссылки указывают на один индексный дескриптор, а права доступа и владелец хранятся в бинарных полях индексного дескриптора.

# *3. Создайте виртуальную машину с новой конфигурацией*

Скопируем информацию ниже в файл Vagrant

```
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
  end
end
```

И запустим виртуальную машину.

```
vagrant up
```

# *4. Разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.*
Используя интерактивный режим fdisk создадим 2 раздела на диске /dev/sdb:

```
vagrant@vagrant:~$ sudo fdisk /dev/sdb
Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 
First sector (2048-5242879, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x54d0bad3

Device     Boot Start     End Sectors Size Id Type
/dev/sdb1        2048 4196351 4194304   2G 83 Linux

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 
First sector (4196352-5242879, default 4196352): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879): 

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x54d0bad3

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

vagrant@vagrant:~$ lsblk 
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk 
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part 
└─sda5                 8:5    0 63.5G  0 part 
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk 
├─sdb1                 8:17   0    2G  0 part 
└─sdb2                 8:18   0  511M  0 part 
sdc                    8:32   0  2.5G  0 disk
```

# *5. Скопируем созданную таблицу разделов на второй диск.*
Используем для этого утилиту 'sfdisk':

```
root@vagrant:~# sfdisk --dump /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x54d0bad3.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x54d0bad3

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

oot@vagrant:~# fdisk -l /dev/sdc
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x54d0bad3

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
root@vagrant:~# lsblk 
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk 
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part 
└─sda5                 8:5    0 63.5G  0 part 
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk 
├─sdb1                 8:17   0    2G  0 part 
└─sdb2                 8:18   0  511M  0 part 
sdc                    8:32   0  2.5G  0 disk 
├─sdc1                 8:33   0    2G  0 part 
└─sdc2                 8:34   0  511M  0 part
```

# *6. Сборка RAID1*
Занулим на всякий случай суперблоки:

```
root@vagrant:~# mdadm --zero-superblock --force /dev/sd{b,c}{1,2}
mdadm: Unrecognised md component device - /dev/sdb1
mdadm: Unrecognised md component device - /dev/sdb2
mdadm: Unrecognised md component device - /dev/sdc1
mdadm: Unrecognised md component device - /dev/sdc2
```

Создадим RAID1:

```
root@vagrant:~# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{b,c}1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

Проверим сборку RAID:

```
root@vagrant:~# mdadm -D /dev/md1 
/dev/md1:
           Version : 1.2
     Creation Time : Fri Nov 26 09:04:16 2021
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Fri Nov 26 09:04:27 2021
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : f707de40:70a76ac0:95e77a5e:9f2a99a2
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1

```

# *7. Сборка RAID0*
Для создания RAID0 используем команду:

```
root@vagrant:~# mdadm --create --verbose /dev/md0 -l 0 -n 2 /dev/sd{b,c}2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

И проверим сборку RAID0:

```
root@vagrant:~# mdadm -D /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Fri Nov 26 09:08:10 2021
        Raid Level : raid0
        Array Size : 1042432 (1018.00 MiB 1067.45 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Fri Nov 26 09:08:10 2021
             State : clean 
    Active Devices : 2
   Working Devices : 2
    Failed Devices : 0
     Spare Devices : 0

            Layout : -unknown-
        Chunk Size : 512K

Consistency Policy : none

              Name : vagrant:0  (local to host vagrant)
              UUID : c53d1b77:08c53f75:b20c5d48:671b7f52
            Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8       34        1      active sync   /dev/sdc2
```

# *8. Создание physical volume на получившихся md-устройствах*

Для создания physical volume используем команду:

```
root@vagrant:~# pvcreate /dev/md{0,1}
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
```

# *9. Создание общей volume-group*

Создадим volume-group:

```
root@vagrant:~# vgcreate VG-ALL /dev/md0 /dev/md1
  Volume group "VG-ALL" successfully created
```

И посмотрим на только что созданную группу и какие PV входят в неё:

```
root@vagrant:~# vgdisplay -v VG-ALL
  --- Volume group ---
  VG Name               VG-ALL
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0   
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               1Vqfbr-aieO-CDt7-Ai78-zslZ-O7Va-v8hfTD
   
  --- Physical volumes ---
  PV Name               /dev/md0     
  PV UUID               O9IbeF-kxA6-2nRq-hcpM-sVPI-Gy1O-EptjM0
  PV Status             allocatable
  Total PE / Free PE    254 / 254
   
  PV Name               /dev/md1     
  PV UUID               bZdofr-oOwE-DSGf-BM6I-Dp9H-Ctiw-RgcCmw
  PV Status             allocatable
  Total PE / Free PE    511 / 511
```

# *10. Создание logical-volume на physical-volume с RAID0.*

Для создания logical-volume используем команду:

```
lvcreate -L 100m -n lv100 VG-ALL /dev/md0
```

У нас появился logical-volume с именем 'lv100', который расположен на RAID0. Это можно увидеть в выводе команды 'lsblk':

```
root@vagrant:~# lsblk 
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
    └─VG--ALL-lv100  253:2    0  100M  0 lvm   
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
    └─VG--ALL-lv100  253:2    0  100M  0 lvm 
```

# *11. Создание файловой системы ext4*

Для создания файловой системы воспользуемся командой:

```
root@vagrant:~# mkfs.ext4 /dev/VG-ALL/lv100 
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

# *12. Монтирование раздела*

Создадим каталог '/tmp/new' и смонтируем logical-volume 'lv100' в этот каталог:

```
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/VG-ALL/lv100 /tmp/new
root@vagrant:~# mount -t ext4
/dev/mapper/vgvagrant-root on / type ext4 (rw,relatime,errors=remount-ro)
/dev/mapper/VG--ALL-lv100 on /tmp/new type ext4 (rw,relatime,stripe=256
```

# *13. Копирование тестового файла*

Скачаем на раздел файл:

```
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-11-26 10:30:03--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22595572 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                      100%[=======================================================================>]  21.55M  1.66MB/s    in 13s     

2021-11-26 10:30:15 (1.69 MB/s) - ‘/tmp/new/test.gz’ saved [22595572/22595572]

root@vagrant:~# ls -l /tmp/new/
total 22084
drwx------ 2 root root    16384 Nov 26 10:20 lost+found
-rw-r--r-- 1 root root 22595572 Nov 26 07:00 test.gz
```

# *14.  Вывод lsblk*

```
root@vagrant:~# lsblk 
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
    └─VG--ALL-lv100  253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
    └─VG--ALL-lv100  253:2    0  100M  0 lvm   /tmp/new
```

# *15. Протестируем целостность файла*

```
root@vagrant:~# gzip -t /tmp/new/test.gz 
root@vagrant:~# echo $?
0
root@vagrant:~# 
```

# *16. Переместим содержимое pysical-volume с RAID0 на RAID1*

Воспользумеся командой 'pvmove':

```
root@vagrant:~# pvmove /dev/md0 /dev/md1
  /dev/md0: Moved: 12.00%
  /dev/md0: Moved: 100.00%
root@vagrant:~# 
```

Из вывода команды 'lsblk' видно, что logical-volume 'lv100' теперь находится на RAID1:

```
root@vagrant:~# lsblk 
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk  
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part  
└─sda5                 8:5    0 63.5G  0 part  
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk  
├─sdb1                 8:17   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
│   └─VG--ALL-lv100  253:2    0  100M  0 lvm   /tmp/new
└─sdb2                 8:18   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0 
sdc                    8:32   0  2.5G  0 disk  
├─sdc1                 8:33   0    2G  0 part  
│ └─md1                9:1    0    2G  0 raid1 
│   └─VG--ALL-lv100  253:2    0  100M  0 lvm   /tmp/new
└─sdc2                 8:34   0  511M  0 part  
  └─md0                9:0    0 1018M  0 raid0
```

# *17. Сделайте --fail на устройство в RAID1*

Сымитируем сбой одного из дисков в RAID 1:

```
root@vagrant:~# mdadm /dev/md1 --fail /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md1

root@vagrant:~# cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks
      
md1 : active raid1 sdc1[1](F) sdb1[0]
      2094080 blocks super 1.2 [2/1] [U_]
      
unused devices: <none>

```

# *18. Сообщение о сбое диска в выводе dmesg*

```
root@vagrant:~# dmesg
....
....
[ 6613.825843] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[ 6613.825871] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[ 7938.349045] md/raid1:md1: Disk failure on sdc1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
root@vagrant:~# 
```

# *19. Повторим проверку целостности файла*

```
root@vagrant:~# ls /tmp/new/
lost+found  test.gz
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0
root@vagrant:~# 
```

Файловая система доступна, целостность файла в порядке.

# *20. Выключение*

Выйдем из гостевой машины и удалим виртальный сервер:

```
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.

vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
```