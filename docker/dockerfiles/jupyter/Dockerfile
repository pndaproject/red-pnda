FROM alpine:3.7 as platformlibs

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

COPY docker/hdfs_root_uri_conf.diff /
RUN apk add --no-cache git bash python py2-pip && pip install setuptools
RUN git clone https://github.com/pndaproject/platform-libraries.git
RUN cd platform-libraries && git checkout tags/release/4.0 && \
    export VERSION=$(git describe --tags) && \
    git apply /hdfs_root_uri_conf.diff && \
    python setup.py bdist_egg

FROM alpine:3.7

COPY --from=platformlibs /platform-libraries/dist/platformlibs-0.1.5-py2.7.egg /
COPY docker /
ENV SPARK_HOME=/opt/spark

RUN apk add --no-cache bash python2 py2-pip postgresql-dev libpng-dev freetype-dev ca-certificates build-base python2-dev krb5-dev libffi-dev cyrus-sasl-dev nodejs shadow python3 python3-dev openjdk8-jre && \
    echo 'Installing python2 requirements' && \
    pip2 install -r /requirements/requirements-jupyter.txt && \
    pip2 install -r /requirements/app-packages-requirements.txt && pip2 install j2cli && \
    /usr/bin/python2 -m ipykernel.kernelspec --name python2 --display-name "Python 2" && \
    echo 'Instaling  python3 requirements' && \
    pip3 install -r /requirements/requirements-jupyter.txt && \
    /usr/bin/python3 -m ipykernel.kernelspec --name python3 --display-name "Python 3" && \
    echo 'Adding pyspark2 support' && \
    mkdir -p /usr/local/share/jupyter/kernels/pyspark2 && mkdir -p /opt && \
    wget -O- https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz | tar -xvz -C /tmp && \
    mv /tmp/spark-2.3.0-bin-hadoop2.7 /opt/spark && \
    echo 'Adding jupyter-scala_extension_spark' && \
    jupyter nbextension enable --py widgetsnbextension --system && \
    jupyter-kernelspec install  /usr/lib/python3.6/site-packages/sparkmagic/kernels/sparkkernel && \
    jupyter serverextension enable --py sparkmagic && \
    echo 'Adding jupyter-extensions' && \
    apk add --no-cache libxml2-dev libxslt-dev && \
    pip3 install -r /requirements/requirements-jupyter-extensions.txt && \
    jupyter serverextension enable --py jupyter_spark --system && \
    jupyter nbextension install --py jupyter_spark --system && \
    jupyter nbextension enable --py jupyter_spark --system && \
    jupyter nbextension enable --py widgetsnbextension --system  && \
    echo 'Adding jupyterhub' && \
    pip3 install -r /requirements/requirements-jupyterhub.txt && \
    npm install -g configurable-http-proxy && mkdir -p /var/log/pnda && \
    echo 'auth    required    pam_exec.so    debug log=/var/log/pnda/login.log /create_notebook_dir.sh' >> /etc/pam.d/login
RUN echo 'Adding pnda platform-libraries' && \
    mkdir /etc/platformlibs && /usr/bin/python2 -m easy_install /platformlibs-0.1.5-py2.7.egg && \
    adduser -D pnda && echo "pnda:pnda" | chpasswd && \
    mkdir -p /opt/pnda && mv /notebooks /opt/pnda/jupyter_notebooks && \
    echo 'auth required pam_listfile.so item=user sense=deny file=/etc/login.deny onerr=succeed' >> /etc/pam.d/login && \
    echo 'root' >> /etc/login.deny

RUN wget http://central.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.11/2.3.0/spark-sql-kafka-0-10_2.11-2.3.0.jar \
-O /opt/spark/jars/spark-sql-kafka-0-10_2.11-2.3.0.jar && \
wget http://central.maven.org/maven2/org/apache/kafka/kafka-clients/1.0.0/kafka-clients-1.0.0.jar \
-O /opt/spark/jars/kafka-clients-1.0.0.jar

ENTRYPOINT /entrypoint.sh

