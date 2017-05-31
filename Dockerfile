FROM openjdk:8-jdk-alpine

ARG kafka_version=0.10.0.0
ARG scala_version=2.10

ENV KAFKA_VERSION=$kafka_version SCALA_VERSION=$scala_version

ENV KAFKA_HOME /opt/kafka
ENV PATH ${PATH}:${KAFKA_HOME}/bin

ADD download-kafka.sh /tmp/download-kafka.sh
ADD start-kafka.sh /usr/local/bin/start-kafka.sh

RUN apk add --update curl jq coreutils bash \
  && sh /tmp/download-kafka.sh && rm /tmp/download-kafka.sh \
  && chmod a+x ${KAFKA_HOME}/bin/*.sh \
  && chmod a+x /usr/local/bin/start-kafka.sh

CMD ["start-kafka.sh"]
