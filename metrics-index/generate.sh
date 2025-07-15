#!/bin/bash

MYDIR=$(dirname $0)

if [ ! -d $MYDIR/output ] ; then
  mkdir $MYDIR/output;
fi

docker run -it --rm \
  -v $MYDIR:/home/weaver/target \
  -v $MYDIR/../model:/model \
  -v $MYDIR/output:/home/weaver/output \
  otel/weaver:v0.16.1 \
  registry generate metrics \
  --registry /model \
  --templates target \


