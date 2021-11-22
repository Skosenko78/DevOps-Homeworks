# **3.3. Операционные системы, часть 1**

# *1. Какой системный вызов делает команда cd?*
Системный вызов можно узнать из вывода команды. Для наглядности отфильтруем вывод командой grep:
 
```
vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep tmp
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe3a3f62a0 /* 33 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
```
Команда cd делает системный вызов chdir()

# *2. Команда file на объекты разных типов.*
Выполним команды, приведённые в примере:

```
vagrant@vagrant:~$ file /dev/tty
/dev/tty: character special (5/0)
vagrant@vagrant:~$ file /dev/sda
/dev/sda: block special (8/0)
vagrant@vagrant:~$ file /bin/bash
/bin/bash: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=a6cb40078351e05121d46daa768e271846d5cc54, for GNU/Linux 3.2.0, stripped
```
Чтобы выяснить, где находится база данных для команды file, воспользуемся командой ниже. Поскольку мы ищем обращения к файлу, то в фильтре укажем, что нас интересуют только системные вызовы, относящиеся к файлам:

```
vagrant@vagrant:~$ strace -e trace=%file file /dev/tty
execve("/usr/bin/file", ["file", "/dev/tty"], 0x7ffd9196ad08 /* 33 vars */) = 0
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
stat("/home/vagrant/.magic.mgc", 0x7ffc680000d0) = -1 ENOENT (No such file or directory)
stat("/home/vagrant/.magic", 0x7ffc680000d0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
lstat("/dev/tty", {st_mode=S_IFCHR|0666, st_rdev=makedev(0x5, 0), ...}) = 0
/dev/tty: character special (5/0)
+++ exited with 0 +++
```

Из вывода видно, что файлом базы данных может быть файл magic или двоичный файл magic.mgc

Также в выводе виден процесс и каталоги поиска данных файлов.

В конечном итоге используется файл '/usr/share/misc/magic.mgc', который в свою очередь является ссылкой на файл '/usr/lib/file/magic.mgc':

```
vagrant@vagrant:~$ ls -l /usr/share/misc/magic.mgc
lrwxrwxrwx 1 root root 24 Jul 28 17:46 /usr/share/misc/magic.mgc -> ../../lib/file/magic.mgc
vagrant@vagrant:~$ ls -l /usr/lib/file/magic.mgc 
-rw-r--r-- 1 root root 5811536 Jan 16  2020 /usr/lib/file/magic.mgc
```

# *3. Обнуление открытого удаленного файла*
Задачу решить не смог, ответов на свои вопросы от экспертов не получил!

Единственное предположение решения задачи:

Восстановить содержимое файла перенаправив вывод файлового дескриптора в файл, затем обнулить содержимое файла перенаправив вывод /dev/null в этот файл.

Но эксперименты показали, что без перезапуска приложения файловый дескриптор все равно продолжает расти.

Для других вариантов знаний не хватает.

# *4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?*
Зомби-процессы ресурсы не занимают, но блокируют записи в таблице процессов, размер которой ограничен.

# *5. Утилита opensnoop*
Вывод утилиты приведён ниже:

```
vagrant@vagrant:~$ sudo opensnoop-bpfcc -d 1
PID    COMM               FD ERR PATH
864    vminfo              6   0 /var/run/utmp
580    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
580    dbus-daemon        18   0 /usr/share/dbus-1/system-services
580    dbus-daemon        -1   2 /lib/dbus-1/system-services
580    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
vagrant@vagrant:~$ 
```

# *6. Какой системный вызов использует uname -a?*
Команда 'uname -a' использует системный вызов 'uname()'. Информацию, отображаемую этой командой, так же можно найти в псевдо файловой системе proc:

```
Part of the utsname information is also accessible via
       /proc/sys/kernel/{ostype, hostname, osrelease, version,
       domainname}.
```

# *7. Последовательность команд через ; и через && в bash*

```
vagrant@vagrant:~$ test -d /tmp/some_dir; echo Hi
Hi
vagrant@vagrant:~$ test -d /tmp/some_dir && echo Hi
vagrant@vagrant:~$ 
```

При использовании ; команды выполняются последовательно на зависимо от результата выполнения.

В случае с && вторая команда выполнится только когда код возврата первой команды равен 0, в нашем случае, только в случае существования '/tmp/some_dir'

Есть ли смысл использовать в bash &&, если применить set -e?

Да, выход из shell произойдёт только если команда после последнего && завершится с кодом выхода не 0.

# *8. Из каких опций состоит режим bash set -euxo pipefail*
Опции:

-e  выход из shell при получении от команды или составной команды не 0 кода завершения

-u  при обращении к не объявленным переменным выход из shell с ошибкой

-x отображать команды скрипта до их выполнения

-o pipefail возвращает не нулевой код возврата последней команды в конвеере или нулевой, если все команды в конвеере выполнены успешно.

Данный режим удобно использовать в сценариях очевидно потому, что возможные ошибки не приводят к зависшим сессиям.

# *9. Наиболее часто встречающийся статус у процессов в системе.*
Статус всех процессов в системе можно узнать командой:

```
ps -auxo stat
```

Больше всего процессов со статусом 'S interruptible sleep'. Дополнительные маленькие буквы означают приоритет процесса, выполнение в фоне, является ли многопоточным и т.д.:

```
               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

```