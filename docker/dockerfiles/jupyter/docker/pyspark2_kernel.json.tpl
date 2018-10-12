{
 "display_name": "PySpark2/Python2",
 "language": "python",
 "argv": [
  "/usr/bin/python2",
  "-m",
  "ipykernel",
  "-f",
  "{connection_file}"
 ],
 "env": {
  "HADOOP_CONF_DIR":"{{HADOOP_CONF_DIR | default('/')}}",
  "PYSPARK_PYTHON":"/usr/bin/python2",
  "SPARK_MAJOR_VERSION":"2",
  "SPARK_HOME": "/opt/spark",
  "WRAPPED_SPARK_HOME": "/usr/",
  "PYTHONPATH": "/usr/lib/python2.7/site-packages:/opt/spark/python:/opt/spark/python/lib/py4j-0.10.6-src.zip",
  "PYTHONSTARTUP": "/opt/spark/python/pyspark/shell.py",
  "PYSPARK_SUBMIT_ARGS": "--master {{SPARK_MASTER_URL | default('spark://spark-master:7077')}} --jars /opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar pyspark-shell"
 }
}
