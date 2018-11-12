FROM openjdk:8u171-jdk-alpine3.7 as builder
ARG version
ENV VERSION $version
RUN apk add --no-cache bash ca-certificates wget
# build pnda-gobblin modules
RUN wget -qO- https://github.com/pndaproject/platform-gobblin-modules/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-gobblin-modules-$VERSION src
RUN cd src && ./build.sh $VERSION



FROM gradiant/gobblin:0.11.0 as pnda-gobblin
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version

ENV GOBBLIN_VERSION=0.11.0
ENV HDFS_URL=hdfs://hdfs-namenode:8020
ENV MAX_MAPPERS=4
ENV KAFKA_BROKERS=kafka:9092
ENV MASTER_DATASET_DIRECTORY=/user/pnda/PNDA_datasets/datasets
ENV MASTER_DATASET_QUARANTINE_DIRECTORY=/user/pnda/PNDA_datasets/quarantine
ENV MASTER_DATASET_COMPACTION_DIRECTORY=/user/pnda/PNDA_datasets/compaction
ENV DATASET_COMPACTION_PATTERN=d

ENV HADOOP_HOME=/

COPY --from=builder /src/pnda-build/gobblin-PNDA-$VERSION.tar.gz /
COPY entrypoint.sh  mr.compact.tpl  mr.pull.tpl /

RUN apk add --no-cache py2-pip && pip install j2cli && \
    tar -xvf gobblin-PNDA-$VERSION.tar.gz -C /gobblin-dist/lib/

ENTRYPOINT ["/entrypoint.sh"]


