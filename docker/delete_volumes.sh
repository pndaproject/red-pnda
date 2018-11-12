#!/bin/bash


docker volume rm $(docker volume ls -f name=red-pnda -q)
