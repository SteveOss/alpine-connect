#!/bin/sh
TAG=1.0.1
if [ "$1" = "squash" ]
then
  SQUASH="--squash"
fi
if [ ! -f P773-VortexEdgeConnect-$TAG-Alpine-x86_64.tar.gz ]
then
  wget http://jenkins.prismtech.com:8080/view/Connect/view/Connect%20Builds/job/CONN_P773/lastSuccessfulBuild/artifact/P773-VortexEdgeConnect-1.0.1-Alpine-x86_64.tar.gz
fi
docker build $SQUASH --tag alpine-connect:$TAG .
docker tag alpine-connect:$TAG adlinktech/alpine-connect:$TAG
docker tag alpine-connect:$TAG adlinktech/alpine-connect:latest
docker push adlinktech/alpine-connect:$TAG
docker push adlinktech/alpine-connect:latest
