FROM alpine:3.7 as builder
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
RUN wget -qO- https://github.com/pndaproject/platform-package-repository/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-package-repository-$VERSION src
RUN  apk add --no-cache bash  build-base maven=3.5.2-r0 grep bc python2-dev py2-nose py2-pip linux-headers && \
     ln -s /usr/bin/nosetests-2.7 /usr/bin/nosetests && \
     pip install pylint==1.6.4 mock==2.0.0 && \
     find /src -name requirements.txt -exec pip install -r '{}' \;
#pnda.io platform-package repository search for Maven 3.0.5. We patch this to use Maven 3.5
RUN sed -i 's/Apache Maven 3.0.5/Apache Maven 3.5/g' /src/build.sh
RUN cd /src && ./build.sh $VERSION

FROM alpine:3.7 as package-repository
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/package-repository-$VERSION.tar.gz /src/api/src/main/resources/requirements.txt /
COPY entrypoint.sh  pr-config.json.tpl /
RUN apk add --no-cache tar bash py2-pip build-base python2-dev linux-headers && pip install j2cli && pip install -r /requirements.txt
RUN tar -xzf /package-repository-$VERSION.tar.gz && mv /package-repository-$VERSION /package-repository
ENTRYPOINT /entrypoint.sh


