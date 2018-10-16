#/bin/sh
j2 /pyspark2_kernel.json.tpl > /usr/local/share/jupyter/kernels/pyspark2/kernel.json
j2 /platformlibs.ini.tpl > /etc/platformlibs/platformlibs.ini
/usr/bin/jupyterhub
