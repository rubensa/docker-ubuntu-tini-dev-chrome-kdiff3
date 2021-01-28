#!/usr/bin/env bash

docker build --no-cache \
  -t "rubensa/ubuntu-tini-dev-chrome-kdiff3" \
  --label "maintainer=Ruben Suarez <rubensa@gmail.com>" \
  .
