# **3.1. Работа в терминале**

# *1. Установите средство виртуализации Oracle VirtualBox.*
В консоли выполняем
 
```
apt-get update 
apt-get install virtualbox
```

# *2. Установите средство автоматизации Hashicorp Vagrant.*
Переходим на https://www.vagrantup.com/downloads.html выбираем соответствующую версию. Копируем команды и в консоли выполняем:

```
url -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant
```

# *3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.*
Используется "Терминал GNOME"

# *4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant*

```
s_kosenko@linuxvb:~/NETOLOGY/Lab3.1Files$ vagrant init -m
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
s_kosenko@linuxvb:~/NETOLOGY/Lab3.1Files$ ls
README.md  Vagrantfile
```

```
s_kosenko@linuxvb:~/NETOLOGY/Lab3.1Files$ more Vagrantfile 
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
end
```

```
s_kosenko@linuxvb:~/NETOLOGY/Lab3.1Files$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'bento/ubuntu-20.04' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'bento/ubuntu-20.04'
    default: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> default: Adding box 'bento/ubuntu-20.04' (v202107.28.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202107.28.0/providers/virtualbox.box
==> default: Successfully added box 'bento/ubuntu-20.04' (v202107.28.0) for 'virtualbox'!
==> default: Importing base box 'bento/ubuntu-20.04'...
...
```

# *5. Ознакомьтесь с графическим интерфейсом VirtualBox.*

Ресурсы выделенные по умолчанию:
- Оперативная память: 1024 Mb
- Процессор: 2
- SATA контроллер с диском ubuntu-20.04-amd64-disk001.vmdk
- Видеопамять: 4 Mb
- Графический контроллер: VBoxVGA
...

# *6. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?*

```
s_kosenko@linuxvb:~/NETOLOGY/Lab3.1Files$ more Vagrantfile 
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.provider "virtualbox" do |vbx|
    vbx.memory = "2048"
    vbx.cpus = "1"
  end
end
```
Теперь в виртуальной машине 1 процессор и 2048 Mb оперативной памяти. После перезапуска виртуальной машины изменения применятся.

# *7. Команда 'vagrant ssh' из директории, в которой содержится Vagrantfile.*

```
s_kosenko@linuxvb:~/NETOLOGY/Lab3.1Files$ vagrant ssh default
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun 14 Nov 2021 06:23:59 PM UTC

  System load:  0.06              Processes:             120
  Usage of /:   2.3% of 61.31GB   Users logged in:       0
  Memory usage: 15%               IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
```

# *8. Ознакомиться с разделами man bash*

- длину журнала history можно задать переменной 'HISTSIZE', это указано на 745 строчке man bash
- директива ignoreboth указывается в качестве значения переменной 'HISTCONTROL'. Означает устанвку обоих значений ignorespace и ignoredups.

ignorespace - строки, начинающиеся с пробела, не сохраняются в списке истории команд

ignoredups - строки, уже существующие в истории, повторно не добавляются

# *9. Применение {} скобок*

Описание применения {} приведено на 232 строчке man bash

{} применяются для создания списков и группы команд.

# *10. Создание множества файлов однократным вызовом*

Попробуем создать 100000 файлов. Для этого используем клманду:

```
touch file{1..100000}
```
Файлы созданы.

Попробуем выполнить команду:

```
touch file{1..300000}
-bash: /usr/bin/touch: Argument list too long
```
Ошибка связана со слишком большим списком аргументов, указанных в командной строке.

# *11. Конструкция [[ -d /tmp ]]*

Данная конструкция проверяет существует ли каталог /tmp и действительно ли он является каталогом.

# *12. Вывод type -a bash*

Текущий вывод:

```
vagrant@vagrant:~$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
```

Создадим нужный каталог и скопируем туда bash:

```
vagrant@vagrant:~$ mkdir /tmp/new_path_directory
vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_directory/
```

Добавим наш каталог в переменную $PATH:

```
vagrant@vagrant:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
vagrant@vagrant:~$ PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/tmp/new_path_directory:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```

# *13. Команды batch и at*

Различие команд в том, что at выполняет команды в заданное время, тогда как batch при определённом уровне загрузки системы.

# *14. Завершение работы*

Завершим работу в виртуальной машине:

```
sudo shutdown -P now
```