FROM alpine:3.7 as builder
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
RUN apk add --no-cache git bash python build-base linux-pam-dev maven=3.5.2-r0 bc grep python2-dev py2-nose py2-pip cyrus-sasl-dev ca-certificates wget\
&& pip install spur==0.3.12 starbase==0.3.2 happybase==1.0.0 pyhs2==0.6.0 pywebhdfs==0.4.0 PyHDFS==0.1.2 cm-api==8.0.0 shyaml==0.4.1 \
nose==1.3.7 mock==2.0.0 pylint==1.6.4 python-swiftclient==3.1.0 tornado==4.4.2 tornado-cors==0.6.0 Tornado-JSON==1.2.2 boto==2.40.0 \
setuptools==28.8.0 --upgrade impyla==0.13.8 eventlet==0.19.0 kazoo==2.2.1 avro==1.8.1 kafka-python==1.3.5 prettytable==0.7.2 \
pyhive==0.2.1 thrift_sasl==0.2.1 JayDeBeApi==1.1.1 \
&& ln -s /usr/bin/nosetests-2.7 /usr/bin/nosetests

RUN wget -qO- https://github.com/pndaproject/platform-testing/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-testing-$VERSION src

#pnda.io platform-testing search for Maven 3.0.5. We patch this to use Maven 3.5
RUN sed -i 's/Apache Maven 3.0.5/Apache Maven 3.5/g' /src/build.sh
RUN cd src && ./build.sh $VERSION


FROM alpine:3.7 as platform-testing
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build /
COPY jinja_entrypoint.sh entrypoint.sh.tpl  hbase_spark_metric.py /
ENTRYPOINT /jinja_entrypoint.sh
RUN apk add --no-cache bash py2-pip tar && tar -xzf /platform-testing-general-${VERSION}.tar.gz \
&& mv /platform-testing-general-${VERSION} /platform-testing-general \
&& pip install j2cli \
&& find /platform-testing-general -name requirements.txt -exec pip install -r '{}' \;

