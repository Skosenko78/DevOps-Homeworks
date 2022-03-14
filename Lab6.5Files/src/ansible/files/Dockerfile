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