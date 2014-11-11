#
# ElasticSearch Dockerfile
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM dockerfile/java

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.0.tar.gz && \
  tar xvzf elasticsearch-1.3.0.tar.gz && \
  rm -f elasticsearch-1.3.0.tar.gz && \
  mv /tmp/elasticsearch-1.3.0 /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

EXPOSE 9200
EXPOSE 9300

# Elasticsearch plugins woop!
RUN /elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head
RUN /elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic
RUN /elasticsearch/bin/plugin -install polyfractal/elasticsearch-segmentspy
RUN /elasticsearch/bin/plugin -install  elasticsearch/marvel/latest

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]
