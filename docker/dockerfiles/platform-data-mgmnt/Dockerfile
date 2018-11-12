FROM alpine:3.7 as builder
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
RUN  apk add --no-cache bash patch build-base maven=3.5.2-r0 grep bc python2-dev py2-nose py2-pip linux-headers ca-certificates wget && \
     ln -s /usr/bin/nosetests-2.7 /usr/bin/nosetests
RUN wget -qO- https://github.com/pndaproject/platform-data-mgmnt/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-data-mgmnt-$VERSION src
RUN  pip install pylint==1.6.4 mock==2.0.0 && \
     find /src -name requirements.txt -exec pip install -r '{}' \;
#pnda.io platform-testing search for Maven 3.0.5. We patch this to use Maven 3.5
RUN sed -i 's/Apache Maven 3.0.5/Apache Maven 3.5/g' /src/build.sh
COPY hdfs-cleaner-env-conf.diff /src/
COPY data-manager-env-conf.diff /src/
RUN cd /src && \
    patch -p1 < hdfs-cleaner-env-conf.diff && \
    patch -p1 < data-manager-env-conf.diff && \
    ./build.sh $VERSION

FROM alpine:3.7 as data-service
LABEL maintainer="cgiraldo@gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/data-service-$VERSION.tar.gz /src/data-service/src/requirements.txt /
COPY data-service /
RUN apk add --no-cache tar bash py2-pip build-base python2-dev linux-headers && pip install j2cli && pip install -r /requirements.txt
RUN tar -xzf /data-service-$VERSION.tar.gz && mv /data-service-$VERSION /data-service
ENV HDFS_URL hdfs-namenode:50070
ENV HBASE_HOST hbase-master
ENTRYPOINT /entrypoint.sh

FROM alpine:3.7 as hdfs-cleaner
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/hdfs-cleaner-$VERSION.tar.gz /src/hdfs-cleaner/src/requirements.txt /
COPY hdfs-cleaner /
RUN apk add --no-cache py-pip build-base linux-pam-dev python2-dev linux-headers tar bash && pip install j2cli && pip install -r /requirements.txt
RUN tar -xzf /hdfs-cleaner-$VERSION.tar.gz && mv /hdfs-cleaner-$VERSION /hdfs-cleaner
ENV HDFS_URL hdfs-namenode:50070
ENV HBASE_HOST hbase-master
ENTRYPOINT /entrypoint.sh

