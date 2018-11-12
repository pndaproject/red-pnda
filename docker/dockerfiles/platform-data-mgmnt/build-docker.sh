#!/bin/bash

VERSION=0.2.2
docker build --build-arg version=$VERSION --target data-service -t pnda/data-service:$VERSION .
docker build --build-arg version=$VERSION --target hdfs-cleaner -t pnda/hdfs-cleaner:$VERSION .
