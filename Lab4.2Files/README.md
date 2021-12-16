# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Ошибка: TypeError: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/test", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result =  os.getcwd() + '/' + result.replace('\tизменено:      ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
user@linuxvb:~/test$ ./gitcm.py 
/home/user/test/file1.txt
/home/user/test/file2.txt
user@linuxvb:~/test$
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

cd_dir = 'cd ' + sys.argv[1]

if sys.argv[1][-1] == '/':
    rep_dir = sys.argv[1]
else:
    rep_dir = sys.argv[1] + '/'

bash_command = [cd_dir, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result =  rep_dir + result.replace('\tизменено:      ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
user@linuxvb:~/NETOLOGY/Lab4.2Files$ ./gitcm_arg.py /home/user/test/
/home/user/test/file1.txt
/home/user/test/file2.txt
user@linuxvb:~/NETOLOGY/Lab4.2Files$ 
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
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
```

### Вывод скрипта при запуске при тестировании:
```
user@linuxvb:~/NETOLOGY/Lab4.2Files$ ./http_host.py 
[ERROR] google.com IP mismatch: 64.233.164.101 64.233.164.139
[ERROR] drive.google.com IP mismatch: 74.125.131.194 173.194.222.194
[ERROR] mail.google.com IP mismatch: 108.177.14.83 142.250.150.83
[ERROR] google.com IP mismatch: 64.233.164.139 64.233.165.101
[ERROR] google.com IP mismatch: 64.233.165.101 64.233.165.139

user@linuxvb:~/NETOLOGY/Lab4.2Files$ ./http_host.py 
[ERROR] google.com IP mismatch: 74.125.205.101 74.125.205.138
[ERROR] mail.google.com IP mismatch: 64.233.165.83 64.233.165.17
[ERROR] mail.google.com IP mismatch: 64.233.165.17 64.233.165.18
[ERROR] mail.google.com IP mismatch: 64.233.165.18 64.233.165.19

user@linuxvb:~/NETOLOGY/Lab4.2Files$ 
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```