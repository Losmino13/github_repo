#!/bin/bash

BASENAME=`basename $0`
DIRNAME=`dirname $0`
TIME=`date +%Y_%m_%d_%H_%M`
DATE=`date +%Y_%m_%d`
LOG_FILE=$DIRNAME/logs/$BASENAME.log
EMAIL=$DIRNAME/logs/$BASENAME.email

#prati ceo disk i obavesti me ako ima manje od 100G slobodno
FREE_SPACE=`df -kh | grep -w /home | awk '{print $3}' | sed -e 's/G//'`
THRESHOLD=200
if [ $FREE_SPACE -lt $THRESHOLD ] 
then
    echo "Threshold violated please check NFS disk!" | mailx -s "exporthome FULL" -r milos.milisavljevic@fisglobal.com milos.milisavljevic@fisglobal.com

fi
#prati user homove i obavesti ako je neko prebacio 5GB
USER_THRESHOLD=5

du -khs /home/* | grep G | egrep -v "oracle|dbdumps" | sed -e 's/\/home\///' > $DIRNAME/logs/users_to_watch.tmp

echo -e "Please clean up your home directories in Belgrade\n" >> $EMAIL
echo "Users who violated threshold" >> $EMAIL

for i in `cat $DIRNAME/logs/users_to_watch.tmp | awk '{print $2}'`
do
    USER_HOME_USAGE=`du -khs /home/$i | awk '{print $1}' | sed -e 's/G//'`
    if [ $(echo "$USER_HOME_USAGE > 5" | bc) -ne 0 ] 
    then
        echo "--- $i" >> $EMAIL 
    fi
done

#Construct infos for email to be sent
echo "" >> $EMAIL
echo "Executed at: " `date` >> $EMAIL
echo "On the host: " `uname -n` " User: " `whoami` >> $EMAIL
echo "Script $DIRNAME/$BASENAME" >> $EMAIL


cat $EMAIL | mailx -s "Belgrade home direcroriums need cleanup" -r milos.milisavljevic@fisglobal.com milos.milisavljevic@fisglobal.com
rm -f $DIRNAME/logs/users_to_watch.tmp
rm -f $EMAIL

#brisi sve core dampove
echo "Removing core.xxxx files from user homes..." >> $LOG_FILE
find /home -type f -name core.[0-9][0-9]\* -mtime +3 -exec rm -f {} \;
if [ $? -eq 0 ] 
then
    echo "Removing files successfull!" >> $LOG_FILE
else
    echo "Removing files failed, check log" >> $LOG_FILE    
fi
