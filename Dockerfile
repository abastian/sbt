FROM openjdk:8-jdk-alpine
RUN apk add --no-cache bash
ENV SBT_HOME=/opt/sbt \
    PATH=${PATH}:/opt/sbt/bin
RUN mkdir -p ${SBT_HOME} &&\
    apk add --no-cache --virtual .build-deps tar curl &&\
    curl -sL "https://github.com/sbt/sbt/releases/download/v1.0.4/sbt-1.0.4.tgz" | gunzip | tar --strip-components=1 -x -C ${SBT_HOME} &&\
    apk del .build-deps
RUN adduser -h /home/builder -D -u 1000 -s /bin/bash -g "Builder" builder
USER builder
WORKDIR /home/builder
RUN ${SBT_HOME}/bin/sbt exit

