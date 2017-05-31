#!/bin/sh

# Optional ENV variables:
# * ADVERTISED_HOST: the external ip for the container, e.g. `docker-machine ip \`docker-machine active\``
# * ADVERTISED_PORT: the external port for Kafka, e.g. 9092
# * ZK_CHROOT: the zookeeper chroot that's used by Kafka (without / prefix), e.g. "kafka"
# * LOG_RETENTION_HOURS: the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week)
# * LOG_RETENTION_BYTES: configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB)
# * NUM_PARTITIONS: configure the default number of log partitions per topic

if [ -f "$KAFKA_HOME/config/server.properties" ]; then
  if [ ! -f "$KAFKA_HOME/config/server.properties.orig" ]; then
    cp "$KAFKA_HOME/config/server.properties" "$KAFKA_HOME/config/server.properties.orig"
  fi
  rm "$KAFKA_HOME/config/server.properties"
fi

if [ -z "$KAFKA_LOGS" ]; then
  KAFKA_LOGS=/var/log/kafka
fi

if [ -z "$KAFKA_STORE_PATH" ]; then
  KAFKA_STORE_PATH=/kafka
fi

if [ -z "$LISTEN_PORT" ]; then
  LISTEN_PORT=9092
fi

if [ -z "$KAFKA_BROKER_ID" ]; then
  KAFKA_BROKER_ID=0
fi

if [ -z "$ADVERTISED_HOST" ]; then
  ADVERTISED_HOST=$(hostname -f)
fi

if [ -z "$ADVERTISED_PORT" ]; then
  ADVERTISED_PORT=${LISTEN_PORT}
fi

if [ -z "$ZOOKEEPER" ]; then
  ZOOKEEPER=localhost:2181
fi


if [ ! -d "${KAFKA_LOGS}" ]; then
  rm -rf "${KAFKA_LOGS}"
  mkdir -p "${KAFKA_LOGS}"
fi 

echo "
broker.id=${KAFKA_BROKER_ID}
listeners=PLAINTEXT://:${LISTEN_PORT}
advertised.host.name=${ADVERTISED_HOST}
advertised.port=${ADVERTISED_PORT}
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=${KAFKA_LOGS}
num.partitions=1
num.recovery.threads.per.data.dir=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
log.cleaner.enable=false
zookeeper.connect=${ZOOKEEPER}${KAFKA_STORE_PATH}
zookeeper.connection.timeout.ms=6000
" | tee -a "$KAFKA_HOME/config/server.properties"

# Run Kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
