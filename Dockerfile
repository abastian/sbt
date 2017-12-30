FROM openjdk:8-jdk-alpine as builder
RUN apk add --no-cache tar curl bash
RUN mkdir -p /tmp/sbt
RUN curl -sL "https://github.com/sbt/sbt/releases/download/v1.0.4/sbt-1.0.4.tgz" | gunzip | tar --strip-components=1 -x -C /tmp/sbt
RUN /tmp/sbt/bin/sbt exit


FROM openjdk:8-jdk-alpine
RUN apk add --no-cache bash
ENV SBT_HOME=/opt/sbt \
    PATH=${PATH}:/opt/sbt/bin
RUN mkdir -p ${SBT_HOME}
COPY --from=builder /tmp/sbt ${SBT_HOME}
RUN adduser -h /home/builder -D -u 1000 -s /bin/bash -g "Builder" builder
RUN mkdir -p /home/builder/.ivy2
RUN mkdir -p /home/builder/.sbt/boot/scala-2.12.4
COPY --from=builder /root/.ivy2 /home/builder/.ivy2
COPY --from=builder /root/.sbt/boot/scala-2.12.4 /home/builder/.sbt/boot/scala-2.12.4
RUN chown -R builder:builder /home/builder/.ivy2
RUN chown -R builder:builder /home/builder/.sbt
USER builder

