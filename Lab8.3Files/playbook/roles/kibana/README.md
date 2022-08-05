Kibana
=========

Simple download binaries from official website and install kibana.

Role Variables
--------------
There are three variables that you can redefine in your playbook.
```yaml
kibana_version: "7.10.1" # Use for download only this version of kibana
kibana_home: "/opt/kibana/{{ kibana_version }}" # Use for unpackage distro
kibana_elastichost: "10.0.0.41:9200" # IP address and port with Elasticsearch
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- hosts: all
  roles:
      - kibana
```

License
-------

BSD

Author Information
------------------

Netology Students
