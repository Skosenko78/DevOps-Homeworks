# **6.5. Elasticsearch**

# **Задача 1**

## *1.1 Текст Dockerfile манифеста*

```
FROM centos:7

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

ENV ES_HOME=/elasticsearch-8.0.1

RUN yum install -y wget perl-Digest-SHA && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz && \
    mkdir $ES_HOME/snapshots && \
    chown elasticsearch:elasticsearch -R $ES_HOME && \
    rm -f elasticsearch-8.0.1-linux-x86_64.tar.gz* && \
    yum -y clean all

RUN mkdir /var/lib/elasticsearch && \
    chown elasticsearch:elasticsearch /var/lib/elasticsearch

COPY elasticsearch.yml $ES_HOME/config/

EXPOSE 9200 9300

USER elasticsearch
CMD ["/elasticsearch-8.0.1/bin/elasticsearch"]
```

## *1.2 Cсылка на образ в репозитории dockerhub*

https://hub.docker.com/repository/docker/sergeyk78/centos7-elastic

## *1.3 Ответ elasticsearch на запрос пути /*

```
[vagrant@elastichost ~]curl -X GET http://127.0.0.1:9200/
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "Tk3EeMPpRs2606nYiDvugw",
  "version" : {
    "number" : "8.0.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "801d9ccc7c2ee0f2cb121bbe22ab5af77a902372",
    "build_date" : "2022-02-24T13:55:40.601285296Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
[vagrant@elastichost ~]$ 
```

# *Задача 2*

## *2.1 Добавить в elasticsearch 3 индекса*

```
curl -X PUT "localhost:9200/ind-1" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'

curl -X PUT "localhost:9200/ind-2" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
'

curl -X PUT "localhost:9200/ind-3" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'
```

## *2.2 Получить список индексов и их статусов, используя API*

```
[vagrant@elastichost ~]$ curl -GET localhost:9200/_cat/indices?v
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 on88rrR2ROa2xUWKw6H_Qw   1   0          0            0       225b           225b
yellow open   ind-3 u3JqRCK6S6OnL2RkmHClkw   4   2          0            0       225b           225b
yellow open   ind-2 LAgpsUOIQUGEr_lOXK-L-Q   2   1          0            0       450b           450b
[vagrant@elastichost ~]$ 
```

## *2.3 Получить состояние кластера elasticsearch, используя API*

```
[vagrant@elastichost ~]$ curl -X GET "localhost:9200/_cat/health?v"
epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1647260633 12:23:53  elasticsearch yellow          1         1      8   8    0    0       10             0                  -                 44.4%
[vagrant@elastichost ~]$
```

## *2.4 Почему часть индексов и кластер находится в состоянии yellow?*

2 индекса имеют статус yellow поскольку не выполняются условия настроек, которые задавались при добавлении индексов. Индексы 'ind-2' и 'ind-3' должны иметь несколько реплик. В нашем случае только 1 node в кластере и индекс не может выполнить заданное условие.

## *2.5 Удалить все индексы*

```
[vagrant@elastichost ~]$ curl -X DELETE "localhost:9200/ind-1"
[vagrant@elastichost ~]$ curl -X DELETE "localhost:9200/ind-2"
[vagrant@elastichost ~]$ curl -X DELETE "localhost:9200/ind-3"
[vagrant@elastichost ~]$ curl -GET localhost:9200/_cat/indices?v
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
[vagrant@elastichost ~]$
```

# *Задача 3*

## *3.1 Зарегистрировать директорию 'snapshot' как snapshot repository c именем netology_backup*

```
curl -X PUT "localhost:9200/_snapshot/netology_backup" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-8.0.1/snapshots"        
  }
}
'
{"acknowledged":true} 
[vagrant@elastichost ~]$
```

## *3.2 Создать индекс test с 0 реплик и 1 шардом*

```
curl -X PUT "localhost:9200/test" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'

[vagrant@elastichost ~]$ curl -GET localhost:9200/_cat/indices?v
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  KlIG05sIQGOHHTcwrD3HMA   1   0          0            0       225b           225b
[vagrant@elastichost ~]$
```

## *3.3 Создать snapshot состояния кластера 'elasticsearch'*

```
[vagrant@elastichost ~]$ curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot",
    "uuid" : "Kto2UThGQKW1JWYdJ4NyYw",
    "repository" : "netology_backup",
    "version_id" : 8000199,
    "version" : "8.0.1",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-03-14T13:11:59.708Z",
    "start_time_in_millis" : 1647263519708,
    "end_time" : "2022-03-14T13:12:02.524Z",
    "end_time_in_millis" : 1647263522524,
    "duration_in_millis" : 2816,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}

[elasticsearch@84a452908a45 /]$ ls -la /elasticsearch-8.0.1/snapshots/
total 32
drwxr-xr-x. 1 elasticsearch elasticsearch   134 Mar 14 13:12 .
drwxr-xr-x. 1 elasticsearch elasticsearch    49 Mar 14 11:20 ..
-rw-r--r--. 1 elasticsearch elasticsearch   841 Mar 14 13:12 index-0
-rw-r--r--. 1 elasticsearch elasticsearch     8 Mar 14 13:12 index.latest
drwxr-xr-x. 4 elasticsearch elasticsearch    66 Mar 14 13:12 indices
-rw-r--r--. 1 elasticsearch elasticsearch 17427 Mar 14 13:12 meta-Kto2UThGQKW1JWYdJ4NyYw.dat
-rw-r--r--. 1 elasticsearch elasticsearch   352 Mar 14 13:12 snap-Kto2UThGQKW1JWYdJ4NyYw.dat
```

## *3.4 Удалить индекс test и создать индекс test-2*

```
[vagrant@elastichost ~]$ curl -X DELETE "localhost:9200/test?pretty"
[vagrant@elastichost ~]$ curl -X PUT "localhost:9200/test-2" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'

[vagrant@elastichost ~]$ curl -GET localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 taspxdOwQ7uufXZenUAKPA   1   0          0            0       225b           225b
[vagrant@elastichost ~]$

```

## *3.5 Восстановить состояние кластера elasticsearch из snapshot*

```
[vagrant@elastichost ~]$ curl -X GET "localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
{
  "snapshots" : [
    {
      "snapshot" : "snapshot",
      "uuid" : "Kto2UThGQKW1JWYdJ4NyYw",
      "repository" : "netology_backup",
      "indices" : [
        ".geoip_databases",
        "test"
      ],
      "data_streams" : [ ],
      "state" : "SUCCESS"
    }
  ],
  "total" : 1,
  "remaining" : 0
}
[vagrant@elastichost ~]$

[vagrant@elastichost ~]$ curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "test"
> }
> '
{
  "accepted" : true
}
[vagrant@elastichost ~]$ curl -GET localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 taspxdOwQ7uufXZenUAKPA   1   0          0            0       225b           225b
green  open   test   wo1YGlABRpO9KtlEYOLBCw   1   0          0            0       225b           225b
[vagrant@elastichost ~]$
```