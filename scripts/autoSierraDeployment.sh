#!/bin/bash

BASENAME=`basename $0`
DIRNAME=`dirname $0`
TIME=`date +%Y_%m_%d_%H_%M`
DATE=`date +%Y_%m_%d`
if [ ! -d $DIRNAME/logs ];
then
mkdir $DIRNAME/logs
fi
LOG_FILE=$DIRNAME/logs/$BASENAME.log
EMAIL=$DIRNAME/logs/$BASENAME.email







