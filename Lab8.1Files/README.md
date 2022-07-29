# **8.1 Введение в Ansible**

# *Основная часть*

1. Запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.

```
ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [localhost]

TASK [Print OS] **************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *******************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Факт 'some_fact' имеет значение 12.

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

Значение переменной 'some_fact' задаётся в файле 'group_vars/all/examp.yml'. Изменим значение:

```
ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [localhost]

TASK [Print OS] **************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *******************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

3. Воспользуемся подготовленным (используется docker) окружением для проведения дальнейших испытаний.

4. Запуск playbook на окружении из prod.yml.

Значения переменной 'some_fact':

- для хоста 'centos7' some_fact=el

- для хоста 'ubuntu' some_fact=deb


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
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.

Изменим переменную 'some_fact' в файлах:

- group_vars/deb/examp.yml some_fact="deb default fact"
- group_vars/el/examp.yml some_fact="el default fact"

6. Повторим запуск playbook на окружении prod.yml

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

7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology

```
ansible-vault encrypt_string "el default fact" --name some_fact:
New Vault password: 
Confirm New Vault password: 
some_fact:: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          36393062353530353137343432646266306438353465666432393733323362386264313964383565
          6138363634616531303661356137356366313232343332340a613964393332383838646535666331
          62323230636230396531323464373138346630666463396235633739663738336663653739633839
          3034336465396533630a613030643764373931616638313131393636313531333965613631386634
          6337
Encryption successful
```

```
ansible-vault encrypt_string "deb default fact" --name some_fact:
New Vault password: 
Confirm New Vault password: 
some_fact:: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          61376363333665396635303939383633613035613262656465386165376637333663653332666662
          3964306236326333356263336565343462336337393532660a353264613635373236383132613537
          63393235353838626464323938613036653334363239646638346637663066386162346535626364
          6531356338356631310a373363373834656639313033343134383532306463383036333633653132
          31303431663730666336616637396131653665636365396639613636616466353536
Encryption successful

```

Присвоим эти значения переменным в файлах group_vars/deb/examp.yml и group_vars/el/examp.yml

8. Запустите playbook на окружении prod.yml. Убедитесь в работоспособности.

```
ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

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
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node

```
ansible-doc -t connection -l
[WARNING]: Collection splunk.es does not support Ansible version 2.12.7
[WARNING]: Collection ibm.qradar does not support Ansible version 2.12.7
[DEPRECATION WARNING]: ansible.netcommon.napalm has been deprecated. See the plugin documentation for more details. This feature will be removed from
 ansible.netcommon in a release after 2022-06-01. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ansible.netcommon.httpapi      Use httpapi to run command on network appliances                                                                  
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection                                                          
ansible.netcommon.napalm       Provides persistent connection using NAPALM                                                                       
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol                                                       
ansible.netcommon.network_cli  Use network_cli to run command on network appliances                                                              
ansible.netcommon.persistent   Use a persistent unix socket for connection                                                                       
community.aws.aws_ssm          execute via AWS Systems Manager                                                                                   
community.docker.docker        Run tasks in docker containers                                                                                    
community.docker.docker_api    Run tasks in docker containers                                                                                    
community.docker.nsenter       execute on host running controller container                                                                      
community.general.chroot       Interact with local chroot                                                                                        
community.general.funcd        Use funcd to connect to target                                                                                    
community.general.iocage       Run tasks in iocage jails                                                                                         
community.general.jail         Run tasks in jails                                                                                                
community.general.lxc          Run tasks in lxc containers via lxc python library                                                                
community.general.lxd          Run tasks in lxc containers via lxc CLI                                                                           
community.general.qubes        Interact with an existing QubesOS AppVM                                                                           
community.general.saltstack    Allow ansible to piggyback on salt minions                                                                        
community.general.zone         Run tasks in a zone instance                                                                                      
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt                                                                           
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines                                                                        
community.okd.oc               Execute tasks in pods running on OpenShift                                                                        
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools                                                                        
community.zabbix.httpapi       Use httpapi to run command on network appliances                                                                  
containers.podman.buildah      Interact with an existing buildah container                                                                       
containers.podman.podman       Interact with an existing podman container                                                                        
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes                                                                       
local                          execute on controller                                                                                             
paramiko_ssh                   Run tasks via python ssh (paramiko)                                                                               
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol                                                             
ssh                            connect via SSH client binary                                                                                     
winrm                          Run tasks over Microsoft's WinRM 
```

Подходящий для работы на control node: local

10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.

Добавим в файл inventory/prod.yml:

```
  local:
    hosts:
      localhost:
        ansible_connection: local
```

11. Запустите playbook на окружении prod.yml

```
ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ********************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************************
ok: [localhost]
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
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *******************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

12. README заполнен:

https://github.com/Skosenko78/DevOps-Homeworks/tree/main/Lab8.1Files/playbook