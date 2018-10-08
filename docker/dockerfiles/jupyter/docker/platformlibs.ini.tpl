[cm]
hadoop_distro={{ HADOOP_DISTRO | default('HDP') }}
hdfs_root_uri={{ HDFS_ROOT_URI | default('hdfs://hdfs-namenode:8020') }}
cm_host={{ CM_HOST | default('cm') }}
cm_user={{ CM_USER | default('scm') }}
cm_pass={{ CM_PASSWORD | default('scm') }}
