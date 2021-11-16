# **3.2. Работа в терминале, 2**

# *1. Какого типа команда cd?*
Тип команды мы можем узнать из вывода:
 
```
type cd
cd is a shell builtin
```
cd - это команда, встроенная в shell. Использование такого типа связано с принципом запуска программ в Linux. При запуске программы делается копия текущего процесса, присваивается новый PID, а затем исполняемый код заменяется кодом новой программы.
После завершения процесса он уничтожается со всеми переменными окружения. И если бы команда cd была не встроена в shell, то при попытке сменить каталог вызывалась бы команда, меняла текущий каталог в своём окружении, успешно завершала работу и процесс со всем окружением уничтожался.
А у текущего процесса bash каталог так и остаётся неизменным.

# *2. Команда grep.*
Вместо выполнения команды 'grep <some_string> <some_file> | wc -l' нужно использовать grep с ключом '-c':

```
grep -c <some_string> <some_file>
```

# *3. Процесс с PID 1*
Процесс /sbin/init является родителем для всех процессов.
/sbin/init, в свою очередь - это ссылка на systemd:

```
vagrant@vagrant:~$ ls -l /sbin/init 
lrwxrwxrwx 1 root root 20 Jul 21 19:00 /sbin/init -> /lib/systemd/systemd
vagrant@vagrant:~$ ls -l /lib/systemd/systemd
```

# *4. Команда для перенаправления вывода stderr ls*
Команда перенаправит вывод stderr из текущей сессии в сессию /dev/tty2

```
vagrant@vagrant:~$ ls nofile 2>/dev/tty2
```
На экране сессии /dev/tty2 появилось сообщение:

```
ls: cannot access 'nofile': No such file or directory
```

# *5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл?*
Да, получится:
```
vagrant@vagrant:~$ man bash | grep HISTSIZE > man.bash.histsize
```

# *6. Возможно ли вывести данные из PTY в какой-либо из эмуляторов TTY?*
Да, возможно:

```
vagrant@vagrant:~$ echo "`Message for TTY1`" > /dev/tty1
```
Сообщение "Message for TTY1" отобразилось на экране tty1

# *7. Команда bash 5>&1*
Данная команда создаст файловый дискриптор №5, который будет ссылаться на тот же файл, что и файловый дескриптор №1:

```
vagrant@vagrant:~$ bash 5>&1
vagrant@vagrant:~$ ls -l /proc/$$/fd/
total 0
lrwx------ 1 vagrant vagrant 64 Nov 15 13:34 0 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Nov 15 13:34 1 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Nov 15 13:34 2 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Nov 15 13:34 255 -> /dev/pts/0
lrwx------ 1 vagrant vagrant 64 Nov 15 13:34 5 -> /dev/pts/0
```

Команда 'echo netology > /proc/$$/fd/5' вывела на экран фразу 'netology'

Так произошло потому, что файловый дискриптор №5 ссылается на файловый дескриптор №1, а это stdout

# *8. Перенаправление только stderr*
Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?

Да, получится. Ниже пример команды, основанный на выполнении пердыдущих пунктов.

У нас существует файл 'man.bash.histsize', создан файловый дескриптор, указывающий на stdout и не существует файл 'nofile'

```
vagrant@vagrant:~$ ls man.bash.histsize nofile 2>&1 >/proc/$$/fd/5 | cat > err.file
man.bash.histsize
vagrant@vagrant:~$ more err.file 
ls: cannot access 'nofile': No such file or directory
```

В результате выполнения команды имя существующего файла выводится на экран, а сообщение об ошибке записывается в файл err.file

# *9. Что выведет команда cat /proc/$$/environ?*
Команда выведет переменные окружения в одну строчку.

Команда 'env' отобразит такие же данные в более читаемом формате.

# *10. Файлы /proc/'PID'/cmdline и /proc/'PID'/exe*
Согласно 'man proc':

- /proc/'PID'/cmdline - содержит полный путь к исполняемому коду процесса со всеми указанными аргументами.
- /proc/'PID'/exe - является символической ссылкой на исполняемый код программы.

# *11. Версия набора инструкций SSE, поддерживаемая процессором*
Данную информацию получаем из '/proc/cpuinfo':

```
flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36
 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl 
 xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 sse4_1 sse4_2
  x2apic popcnt aes xsave avx hypervisor lahf_lm pti md_clear flush_l1d
```
Наиболее старшая версия: sse4_2

# *12. Выполнение команды "ssh localhost 'tty'"*

```
vagrant@vagrant:~$ ssh localhost 'tty'
not a tty
```

Данная конструкция выполняет команду 'tty' в сессии ssh. Но эта команда не предназначена для выполнения вне терминала. Поэтому выдаётся сообщение 'not a tty'.

Чтобы принудительно создать терминал для выполнения команды, нужно использовать ключ '-t':

```
vagrant@vagrant:~$ ssh -t localhost tty 
/dev/pts/1
```

# *13. Reptyr*
Работа программы 'reptyr' проверена на примере по ссылке: https://github.com/nelhage/reptyr из раздела 'Typical usage pattern'

# *14. sudo echo string > /root/new_file*

```
sudo echo string > /root/new_file
-bash: /root/new_file: Permission denied
```
Данная конструкция не выполняется, т.к. у обычного пользователя нет прав записи в домашнюю папку пользователя root.

```
vagrant@vagrant:~$ echo string | sudo tee /root/new_file
string
vagrant@vagrant:~$ sudo ls /root/
new_file
```

А данная конструкция отработала. Команда 'tee' выводит stdin в stdout и в файл. Поскольку мы запустили 'tee' из-под пользователя root (использовали sudo), то в этом случае появились права на запись в домашний каталог пользователя root. Файл создался и команда выполнилась успешно.