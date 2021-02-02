#!/bin/bash
ZQVERSION=v0.28.0
docker login -u="\$app" -p="QRGVFACBAOJHS6TIRBFVNQNDNOXRWW4GX22DPH4IP077QGGANT9KA2V5O8NBPHGYK3V4HBXRB6BHB7UK6C12UUXD0WIQ0DZSXVGP9GGWEA5FJP5PN1CM4KNC" containers.cisco.com
docker build --build-arg ZQVERSION=$ZQVERSION -t containers.cisco.com/evfedoto/zqd:$ZQVERSION -t containers.cisco.com/evfedoto/zqd:latest  .
docker push containers.cisco.com/evfedoto/zqd:$ZQVERSION
docker push containers.cisco.com/evfedoto/zqd:latest