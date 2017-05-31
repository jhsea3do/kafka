#!/bin/sh

mirror=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred')
url="${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
wget "${url}" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
mkdir -p /opt
tar xzf /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /tmp
mv /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION" /opt/kafka
rm -rf /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
