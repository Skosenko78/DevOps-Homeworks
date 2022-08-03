# **8.2 Работа с Playbook**

# *Подготовка к выполнению*

Для выполнения задания создаются 2 виртуальных хоста, конфигурация описана в файле Vagrantfile. Поскольку скачать дистрибутивы не представляется возможным, все архивы скачаны заранее и в ansible play используется копирование из локальной папки.

# *Основная часть*

1. Приготовьте свой собственный inventory файл prod.yml

```
---
elasticsearch:
  hosts:
    elastichost1:
      ansible_connection: ssh
      ansible_host: 10.0.0.41
      ansible_ssh_private_key_file: ".vagrant/machines/elastichost1/virtualbox/private_key"
      ansible_user: vagrant

kibana:
  hosts:
    kibanahost1:
      ansible_connection: ssh
      ansible_host: 10.0.0.42
      ansible_ssh_private_key_file: ".vagrant/machines/kibanahost1/virtualbox/private_key"
      ansible_user: vagrant
```

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.

```
...

- name: Install Kibana
  hosts: kibana
  tasks:
    - name: Upload tar.gz Kibana from local storage
      copy:
        src: "kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
      register: get_kibana
      until: get_kibana is succeeded
      tags: kibana
    - name: Create directrory for Kibana
      become: true
      file:
        state: directory
        path: "{{ kibana_home }}"
      tags: kibana
    - name: Extract Kibana in the installation directory
      become: true
      unarchive:
        copy: false
        src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
        dest: "{{ kibana_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ kibana_home }}/bin/kibana"
      tags:
        - kibana
    - name: Set Kibana config
      become: true
      template:
        src: templates/kibana.yml.j2
        dest: "{{ kibana_home }}/config/kibana.yml"
      tags: kibana
```

3. Для выполнения пункта 2, при создании tasks, использовались модули: copy, template, unarchive, file.

4. Tasks копируют дистрибутивы, выполняют распаковку в нужную директорию, генерируют конфигурации с параметрами на основании шаблонов.

5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.

```
ansible-lint playbook/site.yml
```

Ошибок не обнаружено.

6. Попробуйте запустить playbook на этом окружении с флагом --check

```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --check

PLAY [Install Java] **********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [kibanahost1]
ok: [elastichost1]

TASK [Set facts for Java 11 vars] ********************************************************************************************************************
ok: [elastichost1]
ok: [kibanahost1]

TASK [Upload .tar.gz file containing binaries from local storage] ************************************************************************************
changed: [elastichost1]
changed: [kibanahost1]

TASK [Ensure installation dir exists] ****************************************************************************************************************
changed: [elastichost1]
changed: [kibanahost1]

TASK [Extract java in the installation directory] ****************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [elastichost1]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [kibanahost1]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}

PLAY RECAP *******************************************************************************************************************************************
elastichost1               : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
kibanahost1                : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0 
```

7. Запустите playbook на prod.yml окружении с флагом --diff

```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --diff

PLAY [Install Java] **********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [kibanahost1]
ok: [elastichost1]

TASK [Set facts for Java 11 vars] ********************************************************************************************************************
ok: [elastichost1]
ok: [kibanahost1]

TASK [Upload .tar.gz file containing binaries from local storage] ************************************************************************************
diff skipped: source file size is greater than 104448
changed: [kibanahost1]
diff skipped: source file size is greater than 104448
changed: [elastichost1]

TASK [Ensure installation dir exists] ****************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibanahost1]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elastichost1]

TASK [Extract java in the installation directory] ****************************************************************************************************
changed: [elastichost1]
changed: [kibanahost1]

.....


changed: [kibanahost1]

PLAY RECAP *******************************************************************************************************************************************
elastichost1               : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
kibanahost1                : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Изменения в системах произведены.


8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.

```
ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --diff

PLAY [Install Java] **********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [kibanahost1]
ok: [elastichost1]

TASK [Set facts for Java 11 vars] ********************************************************************************************************************
ok: [elastichost1]
ok: [kibanahost1]

TASK [Upload .tar.gz file containing binaries from local storage] ************************************************************************************
ok: [kibanahost1]
ok: [elastichost1]

TASK [Ensure installation dir exists] ****************************************************************************************************************
ok: [elastichost1]
ok: [kibanahost1]

TASK [Extract java in the installation directory] ****************************************************************************************************
skipping: [elastichost1]
skipping: [kibanahost1]

TASK [Export environment variables] ******************************************************************************************************************
ok: [kibanahost1]
ok: [elastichost1]

PLAY [Install Elasticsearch] *************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [elastichost1]

TASK [Upload tar.gz Elasticsearch from local storage] ************************************************************************************************
ok: [elastichost1]

TASK [Create directrory for Elasticsearch] ***********************************************************************************************************
ok: [elastichost1]

TASK [Extract Elasticsearch in the installation directory] *******************************************************************************************
skipping: [elastichost1]

TASK [Set environment Elastic] ***********************************************************************************************************************
ok: [elastichost1]

PLAY [Install Kibana] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [kibanahost1]

TASK [Upload tar.gz Kibana from local storage] *******************************************************************************************************
ok: [kibanahost1]

TASK [Create directrory for Kibana] ******************************************************************************************************************
ok: [kibanahost1]

TASK [Extract Kibana in the installation directory] **************************************************************************************************
skipping: [kibanahost1]

TASK [Set Kibana config] *****************************************************************************************************************************
ok: [kibanahost1]

PLAY RECAP *******************************************************************************************************************************************
elastichost1               : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
kibanahost1                : ok=9    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

Изменения повторно не применяются.

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

Playbook копирует архивы дистрибутивов Java, Elasticsearch, Kibana из локальной папки, распаковывает их. Для настройки домашних каталогов и конфигурационных файлов используются параметры:

```
java_jdk_version - версия Java
java_oracle_jdk_package - имя архива с Java
elastic_version - версия Elasticsearch
elastic_home - домашняя папка Elasticsearch
kibana_version - версия Kibana
kibana_home - домашняя папка Kibana
kibana_elastichost - адрес хоста с Elasticsearch
```

Для возможности запуска отдельных play в tasks используются теги:

```
java
elastic
kibana
```