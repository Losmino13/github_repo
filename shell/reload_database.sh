#!/bin/bash

#Auditing information
SCRIPT_NAME=${0##*/}
SCRIPT_DIR=${0%/*}
PWD=`pwd`

#Script variables
DUMP_LOCATION=/dbdumps/CT_NRT/dumps
DB_PASS=`cat /home/mmilisav/.pwd.syb`
LOG_FILE=/dbdumps/CT_NRT/latest_reload.log
ISQL=/syb/sybase.linux.12.5.4.64bit.OpenClient/bin/isql
DATE=`date +%Y"-"%m"-"%d`
DATABASE_LIST=$SCRIPT_DIR/database_list.cfg

# Move script log file
if [ -f "$LOG_FILE" ]
then
mv -f $LOG_FILE $SCRIPT_DIR/logs/reload.log.$DATE 2> /dev/null
fi

echo "Starting script $SCRIPT_NAME from $SCRIPT_DIR" > $LOG_FILE
echo "Curent directory is $PWD" >> $LOG_FILE

for i in `cat $DATABASE_LIST`
do
    DATABASE_FROM=`echo $i  | cut -d'>' -f1`
    DATABASE_TO=`echo $i  | cut -d'>' -f2`
    RELOAD_LOG=/dbdumps/CT_NRT/logs/$DATABASE_FROM.to.$DATABASE_TO.$DATE.log

    echo "Reloading $DATABASE_FROM to $DATABASE_TO:" >> $RELOAD_LOG
    echo "on $DATE" >> $RELOAD_LOG
    
    echo "##############################################################" >> $RELOAD_LOG
    echo "" >> $RELOAD_LOG
    
    #First - dump database to dbdumps
    echo "Dumping $DATABASE_FROM . . ." >> $RELOAD_LOG
    echo "--------------------------------------------------------------" >> $RELOAD_LOG

    $ISQL -Usa -SSYB_YARDS -P$DB_PASS << EOF >> $RELOAD_LOG
    use master
    go
    dump database $DATABASE_FROM to 'compress::$DUMP_LOCATION/$DATABASE_FROM.$DATE.dmp'
    go
    exit
EOF
    echo "##############################################################" >> $RELOAD_LOG
    echo "" >> $RELOAD_LOG

    #Second - load dumped database to component tests temp database
    echo "Loading $DATABASE_TO . . ." >> $RELOAD_LOG
    echo "--------------------------------------------------------------" >> $RELOAD_LOG

    $ISQL -Usa -P$DB_PASS -SSYB_YARDS << EOF >> $RELOAD_LOG
    use master
    go
    load database $DATABASE_TO from 'compress::$DUMP_LOCATION/$DATABASE_FROM.$DATE.dmp'
    go
    exit
EOF
    echo "##############################################################" >> $RELOAD_LOG
    echo "" >> $RELOAD_LOG

    #Third: online temp database
    $ISQL -Usa -P$DB_PASS -SSYB_YARDS << EOF >> $RELOAD_LOG
    use master
    go
    online database $DATABASE_TO
    go
    exit
EOF

done

