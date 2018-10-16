#!/bin/bash

VERSION=$(git describe --tags)
docker build --build-arg version=$VERSION -t pnda/console-frontend:$VERSION .
