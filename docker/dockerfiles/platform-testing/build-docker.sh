#!/bin/bash

VERSION=0.5.0
docker build --build-arg version=$VERSION -t pnda/testing:$VERSION .
