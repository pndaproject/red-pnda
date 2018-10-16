#!/bin/bash

VERSION=1.0.0
docker build --build-arg version=$VERSION -t pnda/deployment-manager:$VERSION .
