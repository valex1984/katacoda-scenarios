#!/bin/bash

GIT_URL=http://localhost:32100
USERNAME=argo
REPONAME=gitops
APPPATH=app

git config --global user.email "$USERNAME@example.com"
git config --global user.name "$USERNAME"

if [ ! -d $REPONAME ] ; then
  git clone $GIT_URL/$USERNAME/$REPONAME || exit 1
fi

mkdir -p $REPONAME/$APPPATH \
&& cp nginx-app.yaml $REPONAME/$APPPATH \
&& cd $REPONAME \
&& git add -A \
&& git commit -am "init"

git push origin HEAD