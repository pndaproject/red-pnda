###############################################################################
###################### Gobblin MapReduce configurations #######################
###############################################################################

# File system URIs
fs.uri={{ HDFS_URL }}/
writer.fs.uri=${fs.uri}

job.name=PullFromKafka
job.group=PNDA
job.description=Pulls data from all kafka topics to HDFS

#mr.job.max.mappers={{ MAX_MAPPERS | default('4') }}

#Java Null pointer error if job.lock.enabled
job.lock.enabled=false

# ==== Kafka Source ====
source.class=gobblin.source.extractor.extract.kafka.KafkaDeserializerSource
source.timezone=UTC
source.schema={"namespace": "pnda.entity",                 \
               "type": "record",                            \
               "name": "event",                             \
               "fields": [                                  \
                   {"name": "timestamp", "type": "long"},   \
                   {"name": "src",       "type": "string"}, \
                   {"name": "host_ip",   "type": "string"}, \
                   {"name": "rawdata",   "type": "bytes"}   \
               ]                                            \
              }

kafka.deserializer.type=BYTE_ARRAY
kafka.workunit.packer.type=BI_LEVEL

kafka.brokers={{ KAFKA_BROKERS }}
bootstrap.with.offset=earliest

# ==== Converter ====
converter.classes=gobblin.pnda.PNDAConverter
PNDA.quarantine.dataset.uri=dataset:{{ HDFS_URL }}{{ MASTER_DATASET_QUARANTINE_DIRECTORY }}


# ==== Writer ====
writer.builder.class=gobblin.pnda.PNDAKiteWriterBuilder
kite.writer.dataset.uri=dataset:{{ HDFS_URL }}{{ MASTER_DATASET_DIRECTORY }}

# ==== Metrics ====
metrics.enabled=true
metrics.reporting.file.enabled=true

# ==== Blacklist topics ====
# Recent Kafka version uses internal __consumer_offsets topic, which we don't
# want to ingest
# Don't ingest the avro.internal.testbot topic as it's only an internal PNDA
# testing topic
topic.blacklist=__consumer_offsets,avro.internal.testbot