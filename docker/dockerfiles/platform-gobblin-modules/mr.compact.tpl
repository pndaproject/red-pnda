
###############################################################################
###################### Gobblin Compaction Job configurations ##################
###############################################################################

{%- set compaction_pattern = DATASET_COMPACTION_PATTERN | default('d') %}
{%- if compaction_pattern == 'H' %}
{%- set folder_pattern="'year='YYYY/'month='MM/'day='dd/'hour='HH" %}
{%- set time_ago='1d' %}
{% elif compaction_pattern == 'd' %}
{%- set folder_pattern="'year='YYYY/'month='MM/'day='dd" %}
{%- set time_ago='1d2h' %}
{% elif compaction_pattern == 'M' %}
{%- set folder_pattern="'year='YYYY/'month='MM" %}
{%- set time_ago='1m2h' %}
{% elif compaction_pattern == 'Y' %}
{%- set folder_pattern="'year='YYYY" %}
{%- set time_ago='12m2h' %}
{%- endif %}

# File system URIs
fs.uri={{ HDFS_URL }}/
writer.fs.uri=${fs.uri}

job.name=CompactKafkaMR
job.group=PNDA

#mr.job.max.mappers={{ MAX_MAPPERS | default('4') }}

compaction.datasets.finder=gobblin.compaction.dataset.TimeBasedSubDirDatasetsFinder
compaction.input.dir={{ MASTER_DATASET_DIRECTORY | default('/user/pnda/PNDA_datasets/datasets') }}
compaction.dest.dir={{ MASTER_DATASET_COMPACTION_DIRECTORY | default('/user/pnda/PNDA_datasets/compacted') }}
compaction.input.subdir=.
compaction.dest.subdir=.
compaction.timebased.folder.pattern={{ folder_pattern }}
compaction.timebased.max.time.ago={{ time_ago }}
compaction.timebased.min.time.ago=1h
compaction.input.deduplicated=false
compaction.output.deduplicated=false
compaction.jobprops.creator.class=gobblin.compaction.mapreduce.MRCompactorTimeBasedJobPropCreator
compaction.job.runner.class=gobblin.compaction.mapreduce.avro.MRCompactorAvroKeyDedupJobRunner
compaction.timezone=UTC
compaction.job.overwrite.output.dir=true
compaction.recompact.from.input.for.late.data=true
mapred.output.compress=true
