#!/bin/bash

#baseline
if [ $# -ne 1 ]
then
    echo "Usage: ./createGroupPatch.sh BASELINE"
    exit 1
fi

BASELINE=$1

if [[ ! ${BASELINE} =~ 1[2-3]1[1-9] ]]
then
    echo "Please insert correct baselineUsage: ./createGroupPatch.sh BASELINE"
    exit 1
fi
#echo "Enter baseline"
#read BASELINE

#vars
EXTRACT_DIR=~/group_patch
PATCH_DIR=/syb/sol/${BASELINE}_patch
RELEASE=`ls -ltr ${PATCH_DIR}/*.gz | awk '{print $9}' | awk -F'MR|.00' '{print $2}' | uniq`

ALL_PATCHES=`ls -ltr ${PATCH_DIR}/*.tar.gz | awk -F'[_.]' '{print $6}'`
LAST_PATCH=`ls -ltr ${PATCH_DIR}/*.info | tail -1 | awk -F'[_.]' '{print $6}'`
EAR_PATCHES=`grep -l AmbitSierra.ear ${PATCH_DIR}/*.info | awk -F'[_.]' '{print $5}'`
LAST_EAR_PATCH=`grep -l AmbitSierra.ear ${PATCH_DIR}/*.info | awk -F'[_.]' '{print $5}' | tail -1`

PATCHES_TO_EXTRACT=`echo ${ALL_PATCHES} ${EAR_PATCHES} | tr ' ' '\n' | sort | uniq -u`

cd /syb/sol/${BASELINE}_patch

if [ ! -d ${EXTRACT_DIR} ] 
then
    mkdir ${EXTRACT_DIR}
fi
rm -rf ${EXTRACT_DIR}/*


for VAR in $PATCHES_TO_EXTRACT
do
    gtar -zxvf MR${RELEASE}.00.$VAR.SL.u.tar.gz -C ${EXTRACT_DIR}
    gtar -zxvf MR${RELEASE}.00.${LAST_EAR_PATCH}.SL.u.tar.gz -C ${EXTRACT_DIR}
done

cd ${EXTRACT_DIR}
gtar -zcvf ../MR${RELEASE}.1001-${LAST_PATCH}.tar.gz .






