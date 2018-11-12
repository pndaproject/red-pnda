FROM node:7.3.0-alpine as builder
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
RUN apk add --no-cache bash ca-certificates wget
RUN wget -qO- https://github.com/pndaproject/platform-console-frontend/archive/$VERSION.tar.gz | tar -xvz && \
    mv platform-console-frontend-$VERSION src
RUN sed -i 's/grunt-cli v1.2/grunt-cli v1./g' /src/build.sh
RUN npm install -g grunt-cli && cd src && ./build.sh $VERSION


FROM nginx:1.13.9-alpine
LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"
ARG version
ENV VERSION $version
COPY --from=builder /src/pnda-build/console-frontend-$VERSION.tar.gz /
COPY . /
ENTRYPOINT /entrypoint.sh
RUN apk add --no-cache py2-pip bash && pip install j2cli && \
    tar -xzf /console-frontend-$VERSION.tar.gz --strip 1 -C /usr/share/nginx/html/

