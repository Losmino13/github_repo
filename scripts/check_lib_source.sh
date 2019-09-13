#!/bin/bash

#All files from src/lib
ALL_LIB_SRC_FILES=`ls -ltr /syb/sol/dev/src/lib/libfnx*/*.* | awk '{print $9}' | awk -F"/" '{print $8}'`

rm -f files_in_RCS.txt
for i in $ALL_LIB_SRC_FILES
do
    rlog -R $i >> files_in_RCS.txt 2> /dev/null
done

#parse file_in_RCS.txt
cat files_in_RCS.txt | awk -F"/" '{print $2}' | awk -F"," '{print $1}' > just_file.txt

mkdir -p logs
for i in `cat just_file.txt`
do
    cat RCS/$i,v | grep 13.1.10 > logs/$i
done

ls -ltr logs | grep "fnx   0 " | awk '{print $9}' | egrep -v "tolim|daolim|libversion.c" > files_to_ci.txt

#ci new files
for i in `cat files_to_ci.txt`
do
rcs -M -u13 $i
co -l $i
ci -f -u13.1.10 -m"check in ver 13.1.10" $i
done



