{
  "hadoop_distro": "{{HADOOP_DISTRO | default('hadoop') }}",
  "clustername": "{{CLUSTERNAME | default('pnda')}}",
  "edge_node": "{{ EDGE_NODE | default('pnda') }}",
  "user_interfaces": [
    {
      "name": "Hadoop Cluster Manager",
      "link": "{{ HADOOP_MANAGER_URL |default('hadoop-manager')}}"
    },
    {
      "name": "Kafka Manager",
      "link": "{{ KAFKA_MANAGER_URL |default('http://kafka-manager:10900')}}"
    },
    {
      "name": "OpenTSDB",
      "link": "{{ OPENTSDB_URL |default('http://opentsdb:4242') }}"
    },
    {
      "name": "Grafana",
      "link": "{{ GRAFANA_URL | default('http://grafana:3000')}}"
    },
    {
      "name": "PNDA logserver",
      "link": "{{ KIBANA_URL | default('pnda')}}"
    },
    {
      "name": "Jupyter",
      "link": "{{ JUPYTER_URL | default('http://jupyter:8000')}}"
    },
    {
      "name": "Flink",
      "link": "{{ FLINK_URL | default('pnda')}}"
    }
  ],
  "frontend": {
    "version": "{{ VERSION | default('1.0.0')}}"
  },
  "backend": {
    "data-manager": {
      "version": "{{DATA_MANAGER_VERSION| default('1.0.0')}}",
      "host": "{{DATA_MANAGER_HOST| default('127.0.0.1')}}", "port": "{{DATA_MANAGER_PORT| default('3123')}}"
    }
  },
  "login_mode": "{{ LOGIN_MODE | default('PAM')}}"
}
