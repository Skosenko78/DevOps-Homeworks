# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис:

```
{ "info" : "Sample JSON output from our service\t",
  "elements" :[
      { "name" : "first",
      "type" : "server",
      "ip" : "7175" 
      },
      { "name" : "second",
      "type" : "proxy",
      "ip" : "71.78.22.43"
      }
  ]
}
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import json
import yaml

hosts_dict = {'drive.google.com':'','mail.google.com':'','google.com':''}

for keys in hosts_dict:
  hosts_dict[keys] = socket.gethostbyname(keys)
  fjson = open ('http_hosts.json', 'w')
  fjson.write(json.dumps(hosts_dict))
  fjson.close()
  fyaml = open ('http_hosts.yml', 'w')
  fyaml.write(yaml.dump(hosts_dict, indent=3))
  fyaml.close()

while True:
  for keys in hosts_dict:
    current_IP = socket.gethostbyname(keys)
    if current_IP !=  hosts_dict[keys]:
      print ('[ERROR] {} IP mismatch: {} {}'.format(keys, hosts_dict[keys], current_IP))
      hosts_dict[keys] = current_IP
      with open ('http_hosts.json', 'w') as fjson:
        fjson.write(json.dumps(hosts_dict))
      with open ('http_hosts.yml', 'w') as fyaml:
        fyaml.write(yaml.dump(hosts_dict, indent=3))
```

### Вывод скрипта при запуске при тестировании:
```
user@linuxvb:~/NETOLOGY/Lab4.3Files$ ./http_host.py 
[ERROR] mail.google.com IP mismatch: 64.233.165.18 64.233.165.83
[ERROR] google.com IP mismatch: 74.125.205.101 74.125.205.138
...
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "108.177.14.194", "mail.google.com": "64.233.165.83", "google.com": "74.125.205.138"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 108.177.14.194
google.com: 74.125.205.138
mail.google.com: 64.233.165.83
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???