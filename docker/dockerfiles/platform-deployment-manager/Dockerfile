FROM alpine:3.7 as builder
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
RUN  apk add --no-cache bash patch build-base maven=3.5.2-r0 grep bc libffi-dev openssl-dev cyrus-sasl-dev python2-dev py2-nose py2-pip linux-headers ca-certificates wget && \
     ln -s /usr/bin/nosetests-2.7 /usr/bin/nosetests && \
     pip install pylint==1.6.4 mock==2.0.0
RUN wget -qO- https://github.com/pndaproject/platform-deployment-manager/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-deployment-manager-$VERSION /src
RUN find /src -name requirements.txt -exec pip install -r '{}' \;
COPY opentsdb_with_cli.diff add_env_config.diff /src/
#pnda.io platform-testing search for Maven 3.0.5. We patch this to use Maven 3.5
RUN sed -i 's/Apache Maven 3.0.5/Apache Maven 3.5/g' /src/build.sh
RUN cd /src && patch -p1 < add_env_config.diff && \
    patch -p1 < opentsdb_with_cli.diff && \
    ./build.sh $VERSION

FROM openjdk:8u171-jdk-alpine3.8 as deployment-manager
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/deployment-manager-$VERSION.tar.gz /src/api/src/main/resources/requirements.txt /
COPY usr/ opt/ entrypoint.sh dm-config.json.tpl /
RUN apk add --no-cache sudo tar bash py2-pip build-base python2-dev libffi-dev openssl-dev cyrus-sasl-dev linux-headers openssh-client && pip install j2cli && pip install -r /requirements.txt
RUN tar -xzf /deployment-manager-$VERSION.tar.gz && mv /deployment-manager-$VERSION /deployment-manager
ENTRYPOINT /entrypoint.sh

ENV SPARK_HOME=/opt/spark
RUN mkdir -p /opt && \
    wget -O- https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz | tar -xvz -C /tmp && \
    mv /tmp/spark-2.3.0-bin-hadoop2.7 /opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin
