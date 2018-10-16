#!/bin/bash

VERSION=1.0.0
docker build --build-arg version=$VERSION --target console-backend-data-logger -t pnda/console-backend-data-logger:$VERSION .
docker build --build-arg version=$VERSION --target console-backend-data-manager -t pnda/console-backend-data-manager:$VERSION .
