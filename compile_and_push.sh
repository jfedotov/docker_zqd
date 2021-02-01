#!/bin/bash
#ZQVERSION=v0.28.0
docker build --build-arg ZQVERSION=$ZQVERSION -t jfedotov/zqd:$ZQVERSION -t jfedotov/zqd:latest  .
docker push jfedotov/zqd:$ZQVERSION
docker push jfedotov/zqd:latest