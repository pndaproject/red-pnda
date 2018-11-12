
{
    "environment": {
        "hadoop_distro":"{{ HADOOP_DISTRO | default('env') }}",
        "hadoop_manager_host" : "{{ CM_HOST_IP | default('ambari-server') }}",
        "hadoop_manager_username" : "{{ CM_USERNAME | default('admin') }}",
        "hadoop_manager_password" : "{{ CM_PASSWORD | default('admin') }}",
        "cluster_root_user" : "{{ OS_USER | default('root') }}",
        "cluster_private_key" : "{{ KEYS_DIRECTORY | default('/opt/pnda/dm_keys') }}/dm.pem",
        "kafka_zookeeper" : "{{ ZOOKEEPERS| default('zookeeper:2181') }}",
        "kafka_brokers" : "{{ KAFKA_BROKERS|default('kafka:9092') }}",
        "opentsdb" : "{{ OPENTSDB| default('opentsdb:4242')}}",
        "kafka_manager" : "{{ KAFKA_MANAGER_URL | default('http://kafka-manager:10900') }}",
        "namespace": "platform_app",
        "metric_logger_url": "{{ DATA_LOGGER_URL |default('console_backend_data_logger:3001') }}/metrics",
        "jupyter_host": "{{ JUPYTER_HOST | default('jupyter_host') }}",
        "jupyter_notebook_directory": "{{ JUPYTER_NOTEBOOK_DIRECTORY | default('jupyter_notebooks') }}",
        "app_packages_hdfs_path":"{{ APP_PACKAGES_HDFS_PATH | default('/pnda/deployment/app_packages') }}",
        "queue_policy": "{{ POLICY_FILE_LINK | default('/opt/pnda/rm-wrapper/yarn-policy.sh') }}",
        "name_node":"{{ HDFS_ROOT_URI | default('hdfs://hdfs-namenode') }}",
        "webhdfs_host":"{{ WEBHDFS_HOST | default('hdfs-namenode') }}",
        "webhdfs_port":"{{ WEBHDFS_PORT | default('50070') }}",
        "hbase_thrift_server":"{{ HBASE_THRIFT_SERVER | default('hbase-master') }}",
        "yarn_node_managers":"{{ YARN_NODE_MANAGERS | default('yarn-node-manager') }}",
        "yarn_resource_manager_host":"{{ YARN_RESOURCE_MANAGER_HOST | default('') }}",
        "yarn_resource_manager_port":"{{ YARN_RESOURCE_MANAGER_PORT | default('') }}",
        "yarn_resource_manager_mr_port":"{{ YARN_RESOURCE_MANAGER_MR_PORT | default('') }}",
        "zookeeper_quorum":"{{ ZOOKEEPER_QUORUM | default('zookeeper') }}",
        "oozie_uri":"{{ OOZIE_URI | default('http://oozie:11000') }}"
    },
    "config": {
        "stage_root": "stage",
        "plugins_path": "plugins",
        "log_level": "{{ LOG_LEVEL | default('INFO') }}",
        "deployer_thread_limit": 100,
        "environment_sync_interval": 120,
        "package_callback": "{{ DATA_LOGGER_URL |default('console_backend_data_logger:3001')}}/packages",
        "application_callback": "{{ DATA_LOGGER_URL|default('console_backend_data_logger:3001') }}/applications",
        "package_repository": "{{ PACKAGE_REPOSITORY_URL |default('http://package-repository:8888') }}"
    }
}
