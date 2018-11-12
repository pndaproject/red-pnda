#!/bin/bash

VERSION=0.1.0
docker build --build-arg version=$VERSION -t pnda/gobblin:0.11.0-$VERSION .
