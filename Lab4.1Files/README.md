# **4.1. Командная оболочка Bash: Практические навыки**

# *1. Значения переменных*
Скрипт

```
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
``` 

После выполнения скрипта переменные примут следующие значения:

```
a=1
b=2
c=a+b
d=1+2
e=3
```

Переменная 'с' получает такое значение, т.к. ей присваиваются не значения переменных 'a' и 'b', а строка 'a+b'

Переменной 'd' присваиваются значения переменных 'a' и 'b', но переменные определены неявно и в данной конструкции воспринимаются как строковые значения.

Конструкция '$(())' преобразует неявно определённые переменные в целочисленные, поэтому выполняется арифметическая операция, после которой переменная 'e' принимает значение 3.

# *2. Скрипт с ошибкой*
Скрипт не имеет точки выхода из цикла. Даже при успешном подключении к сервису проверка подключения продолжится и в лог 'curl.log' будут добавляться записи. Нужно добавить 'break' или 'exit' в случае успешного завершения команды 'curl https://localhost:4757':

```
while ((1==1))
do
    curl https://localhost:4757
if (($? != 0))
then
    date >> curl.log
else
    break
fi
done
```

# *3. Скрипт для проверки доступности сервиса*

Скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверка делается пять раз для каждого узла.

```
#!/usr/bin/env bash

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
```

# *4. Скрипт для проверки недоступности сервиса*

Скрипт выполняется до тех пор, пока сервис на одном из узлов не окажется недоступным. Если сервис на любом из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

```
#!/usr/bin/env bash

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
```