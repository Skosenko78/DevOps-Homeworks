# **8.3 Работа с Roles**

# *Подготовка к выполнению*

Созданы публичные репозитории elastic-role и kibana-role. Установлен инструмент `molecule`. Запущены контейнеры `centos7elastic` и `centos7kibana`

# *Основная часть*

1. Создадим в старой версии playbook файл requirements.yml со следующим содержимым:


```
---
  - src: git@github.com:netology-code/mnt-homeworks-ansible.git
    scm: git
    version: "1.0.1"
    name: java 
```



2. При помощи ansible-galaxy скачаем роль и запустим molecule test.

```
ansible-galaxy install -r requirements.yml 
Starting galaxy role install process
- extracting java to /home/s_kosenko/NETOLOGY/Lab8.3Files/playbook/roles/java
- java (1.0.1) was installed successfully
```

```
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/s_kosenko/.cache/ansible-compat/38a096/modules:/home/s_kosenko/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/s_kosenko/.cache/ansible-compat/38a096/collections:/home/s_kosenko/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/s_kosenko/.cache/ansible-compat/38a096/roles:/home/s_kosenko/NETOLOGY/Lab8.3Files/playbook/roles:/home/s_kosenko/NETOLOGY/Lab8.3Files/playbook/roles
INFO     Using /home/s_kosenko/.cache/ansible-compat/38a096/roles/alexeymetlyakov.java symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/s_kosenko/NETOLOGY/Lab8.3Files/playbook/roles/java/molecule/default/converge.yml
INFO     Running default > create
.....
.....
TASK [Check Java can running] **************************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

3. Перейдём в каталог с ролью elastic-role и создадим сценарий тестирования по умолчаню:

```
molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/s_kosenko/ANSIBLE_ROLES/elasticsearch/molecule/default successfully.
```
4. Добавим несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируем роль.

Изменим в файле molecule.yml секцию platforms. Приведём к виду:

```
platforms:
  - name: centos8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: ubuntu
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
```

```
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/s_kosenko/.cache/ansible-compat/ae1b8c/modules:/home/s_kosenko/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/s_kosenko/.cache/ansible-compat/ae1b8c/collections:/home/s_kosenko/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/s_kosenko/.cache/ansible-compat/ae1b8c/roles:/home/s_kosenko/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/s_kosenko/.cache/ansible-compat/ae1b8c/roles/alexeymetlyakov.elasticsearch symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax
....
....
PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

Пришлось изменить файл main.yml в папке tasks, чтобы дистрибутив копировался из локальной папки, т.к. ссылки недоступны.

5. Создадим новый каталог с ролью при помощи molecule init role:

````
molecule init role -d docker --verifier-name ansible myrole.kibana
INFO     Initializing new role kibana...
Using /etc/ansible/ansible.cfg as config file
- Role kibana was created successfully
Invalid -W option ignored: unknown warning category: 'CryptographyDeprecationWarning'
Invalid -W option ignored: unknown warning category: 'CryptographyDeprecationWarning'
localhost | CHANGED => {"backup": "","changed": true,"msg": "line added"}
INFO     Initialized role in /home/s_kosenko/ANSIBLE_ROLES/kibana successfully.
````

6. На основе tasks из старого playbook заполним новую role. Проведем тестирование на разных дистрибитивах (centos:7, centos:8, ubuntu).

```
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/s_kosenko/.cache/ansible-compat/805c02/modules:/home/s_kosenko/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/s_kosenko/.cache/ansible-compat/805c02/collections:/home/s_kosenko/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/s_kosenko/.cache/ansible-compat/805c02/roles:/home/s_kosenko/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/s_kosenko/.cache/ansible-compat/805c02/roles/kibanarole.kibana symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax
....
....
PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

```
ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Print os facts] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
[WARNING]: Distribution ubuntu 20.04 on host ubuntu should use /usr/bin/python3, but is using /usr/bin/python3.9, since the discovered platform
python interpreter was not present. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for more
information.
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] **************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact'"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Выложим все roles в репозитории. Проставим тэги, используя семантическую нумерацию.

```
git tag -a 1.0.0 -m "Initial tag"
git push origin 1.0.0

```

8. Добавим roles в requirements.yml в playbook:

```
---
  - src: git@github.com:netology-code/mnt-homeworks-ansible.git
    scm: git
    version: "1.0.1"
    name: java

  - src: git@github.com:Skosenko78/kibana-role.git
    scm: git
    version: "1.0.0"
    name: kibana 

  - src: git@github.com:Skosenko78/elastic-role.git
    scm: git
    version: "1.0.0"
    name: elasticsearch 
```

Установим роли:

```
ansible-galaxy install -r requirements.yml
```

9. Переделаем playbook на использование roles и запустим playbook:

```
ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Install Java] **********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [centos7elastic]
ok: [centos7kibana]

TASK [java : Upload .tar.gz file containing binaries from local storage] *****************************************************************************
changed: [centos7elastic]
changed: [centos7kibana]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] *****************************************************************************
skipping: [centos7elastic]
skipping: [centos7kibana]

TASK [java : Ensure installation dir exists] *********************************************************************************************************
changed: [centos7elastic]
changed: [centos7kibana]

TASK [java : Extract java in the installation directory] *********************************************************************************************
changed: [centos7elastic]
changed: [centos7kibana]

TASK [java : Export environment variables] ***********************************************************************************************************
changed: [centos7elastic]
changed: [centos7kibana]

PLAY [Install Elasticsearch] *************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [centos7elastic]

TASK [elasticsearch : Upload tar.gz Elasticsearch from local storage] ********************************************************************************
changed: [centos7elastic]

TASK [elasticsearch : Create directrory for Elasticsearch] *******************************************************************************************
changed: [centos7elastic]

TASK [elasticsearch : Extract Elasticsearch in the installation directory] ***************************************************************************
changed: [centos7elastic]

TASK [elasticsearch : Set environment Elastic] *******************************************************************************************************
changed: [centos7elastic]

PLAY [Install Kibana] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [centos7kibana]

TASK [kibana : Upload tar.gz Kibana from local storage] **********************************************************************************************
changed: [centos7kibana]

TASK [kibana : Create directrory for Kibana] *********************************************************************************************************
changed: [centos7kibana]

TASK [kibana : Extract Kibana in the installation directory] *****************************************************************************************
changed: [centos7kibana]

TASK [kibana : Set Kibana config] ********************************************************************************************************************
changed: [centos7kibana]

PLAY RECAP *******************************************************************************************************************************************
centos7elastic             : ok=10   changed=8    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
centos7kibana              : ok=10   changed=8    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0 
```

10. Playbook в репозитории, но без архивов дистрибутивов.

11. Ссылки на репозитории с roles на репозиторий с playbook:

https://github.com/Skosenko78/elastic-role

https://github.com/Skosenko78/kibana-role

https://github.com/Skosenko78/DevOps-Homeworks/tree/main/Lab8.3Files/playbook