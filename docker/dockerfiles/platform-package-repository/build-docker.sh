#!/bin/bash

VERSION=0.3.2
docker build --build-arg version=$VERSION  -t pnda/package-repository:$VERSION .
