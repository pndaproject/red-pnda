FROM node:7.3.0-alpine as builder
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
RUN apk add --no-cache bash build-base python linux-pam-dev ca-certificates wget
RUN wget -qO- https://github.com/pndaproject/platform-console-backend/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-console-backend-$VERSION src
RUN npm install -g grunt-cli
RUN sed -i 's/grunt-cli v1.2/grunt-cli v1./g' /src/build.sh
RUN cd src && ./build.sh $VERSION


FROM node:7.3.0-alpine as console-backend-data-logger
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/console-backend-data-logger-$VERSION.tar.gz /src/pnda-build/console-backend-utils-$VERSION.tar.gz /
COPY console-backend-data-logger /
RUN apk add --no-cache py-pip tar bash && pip install j2cli
RUN tar -xzf /console-backend-data-logger-$VERSION.tar.gz && mv /console-backend-data-logger-$VERSION /console-backend-data-logger
RUN tar -xzf /console-backend-utils-$VERSION.tar.gz && mv /console-backend-utils-$VERSION /console-backend-utils
ENTRYPOINT /entrypoint.sh

FROM node:7.3.0-alpine as console-backend-data-manager
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/console-backend-data-manager-$VERSION.tar.gz /src/pnda-build/console-backend-utils-$VERSION.tar.gz /
COPY console-backend-data-manager /
RUN apk add --no-cache py-pip build-base linux-pam-dev tar bash && pip install j2cli && \
    tar -xzf /console-backend-data-manager-$VERSION.tar.gz && \
    mv /console-backend-data-manager-$VERSION /console-backend-data-manager && \
    tar -xzf /console-backend-utils-$VERSION.tar.gz && \
    mv /console-backend-utils-$VERSION /console-backend-utils && \
    adduser -D pnda && echo "pnda:pnda" | chpasswd && \
    echo 'auth required pam_listfile.so item=user sense=deny file=/etc/login.deny onerr=succeed' >> /etc/pam.d/login && \
    echo 'root' >> /etc/login.deny
ENTRYPOINT /entrypoint.sh

