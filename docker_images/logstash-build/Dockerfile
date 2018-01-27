FROM docker.elastic.co/logstash/logstash-oss:6.1.1

# Upgrading gelf input plugin to 3.1.0 because it adds support for tcp
# and the latest version of the logstash docker image (6.1.2) doesn't yet
# have it included
RUN logstash-plugin install --version 3.1.0 logstash-input-gelf
