# Set PATH variables
set PATH = ${ORACLE_HOME}/bin:$PATH ;
set LD_LIBRARY_PATH = ${ORACLE_HOME}/lib:${LD_LIBRARY_PATH} ;
set LD_LIBRARY_PATH_64 = ${ORACLE_HOME}/lib ;

set timeStamp = `date +'%Y-%m-%d_%H%M%S'`
set SCRIPT_OUTPUT_FILE = "oracleSchemaExpImp.${timeStamp}.out.txt"

################################################################################
## ALIASES
##

alias print_usage \
 'echo;\
  echo USAGE:;\
  echo;\
  echo Print config file template:;\
  echo "    "./oracleSchemaExpImp.sh -printConfig \<export\|import\>;\
  echo;\
  echo Use config file:;\
  echo "    "./oracleSchemaExpImp.sh -configFile \<config_file_name\>;\
  echo;\
  echo Export usage:;\
  echo "    "./oracleSchemaExpImp.sh -doExport -oracleSid \<ORACLE_SID\> -sysPasswdFile \<syspwd\> -dboUserId \<dboUser\>;\
  echo "                            "-dboPassword \<dboPwd\> -backupDir \<backupDirObject\> -dateOnly;\
  echo;\
  echo Import usage:;\
  echo "    "./oracleSchemaExpImp.sh -doImport -oracleSid \<ORACLE_SID\>;\
  echo "                            "-sysPasswdFile \<syspwd\> -dboUserId \<dboUser\> -origDboUserId \<origDboUser\> -dboPassword \<dboPwd\>;\
  echo "                            "-ssoUserId \<ssoUserId\> -ssoPassword \<ssoPassword\> -backupDir \<backupDirOnServer\>;\
  echo "                            "-backupFile \<backupFile\> -tableSpaceDir \<tableSpaceDir\> \[ -disableDeleteUsers \<disableDeleteUsers\> \];\
  echo;\
 '

# Check exit code and leave script if necessary.
alias check_exit_code \
 'set exit_code = $?;\
  if (${exit_code} != 0 && ${exit_code} != 5) then\
    echo;\
    echo;\
    echo "Something went wrong, exit code == ${exit_code}";\
    echo "Exiting, check ${SCRIPT_OUTPUT_FILE} for more info.";\
    echo;\
    echo;\
    exit 1;\
  endif\
 '

alias unset_all 'unset oracleSid;unset sysPasswdFile; unset dboUserId; unset origDboUser;\
         unset dboPassword; unset dboPassword; unset ssoPassword; unset ssoUserId; unset backupDir;\
         unset backupFile; unset tableSpaceDir; unset configFile; unset doExport; unset doImport; unset printConfig; unset disableDeleteUsers; unset dateOnly; unset encryptionPassword; unset tablespaceType '

alias print_config_file_template_export \
   'echo \#;\
    echo \#\# Uncomment \(if needed\) and set proper value. The file will be;\
    echo \#\# sourced in the script and uncommented values will be picked from here.;\
    echo \#;\
    echo set doExport;\
    echo ;\
    echo \#\# Oracle SID of the server we are running export on;\
    echo set oracleSid =;\
    echo ;\
    echo \#\# Path to the file that holds SYS password of the server we run export on;\
    echo \#\# File permissions need to be set so no one else can read the file.;\
    echo set sysPasswdFile = ;\
    echo ;\
    echo \#\# DBO user / SCHEMA name you want to export;\
    echo set dboUserId =;\
    echo ;\
    echo \#\# DBO user password;\
    echo set dboPassword =;\
    echo ;\
    echo \#\# Backup directory \(directory object on Oracle server\). User must make sure that directory exists;\
    echo set backupDir =;\
    echo ;\
    echo \#\# Uncomment to turn on. If on, dump file will only have date in the name, no time.\
    echo \# set dateOnly;\
    echo ;\
    echo \#\# Uncomment to set up ENCRYPTION PASSORD. Otherwise, dump file will be no encrypted.\
    echo \# set encryptionPassword=Sierra\
   '

alias print_config_file_template_import \
   'echo \#;\
    echo \#\# Uncomment \(if needed\) and set proper value. The file will be;\
    echo \#\# sourced in the script and uncommented values will be picked from here.;\
    echo \#;\
    echo ;\
    echo set doImport;\
    echo ;\
    echo \#\# Oracle SID of the server we are running import on;\
    echo set oracleSid =;\
    echo ;\
    echo \#\# Path to the file that holds SYS password of the server we run export on;\
    echo \#\# File permissions need to be set so no one else can read the file.;\
    echo set sysPasswdFile = ;\
    echo ;\
    echo \#\# New DBO user / SCHEMA name;\
    echo set dboUserId =;\
    echo ;\
    echo \#\# New DBO user password;\
    echo set dboPassword =;\
    echo ;\
    echo \#\# Original DBO user / SCHEMA name;\
    echo set origDboUserId =;\
    echo ;\
    echo \#\# New SSO user. If not set sso user id will be created by appending "SSO" to;\
    echo \#\# dbo user id \(e.g. dbo = TEST, sso = TESTSSO\);\
    echo \# set ssoUserId =;\
    echo ;\
    echo \#\# New SSO user password;\
    echo set ssoPassword =;\
    echo ;\
    echo \#\# Backup directory \(directory object on Oracle server\) where import file is placed. User must make sure that;\
    echo \#\# directory existits on server;\
    echo set backupDir = ;\
    echo ;\
    echo \#\# Backup file name \(on server\) to use for import. If backupFile contains a percentage character,\
    echo \#\# this portion of the string will be replaced with a current date. E.g. backupFile is set to\
    echo \#\# TEST.%.dmp, on Mar 17 2015, the script will look for a file named TEST.2015-03-17.dmp\
    echo set backupFile =;\
    echo ;\
    echo \#\# Table space dir \(on server file system\). User must make sure this folder exists on server.\
    echo set tableSpaceDir =;\
    echo ;\
    echo \#\# Uncomment to define BIGFILE tablespace type.\
    echo \# set tablespaceType=BIGFILE\
    echo ;\
    echo \#\# Uncomment to set up ENCRYPTION PASSORD. Otherwise, it is expected that dump file was not encrypted.\
    echo \# set encryptionPassword=Sierra\
    echo ;\
    echo \#\# What to do with other users \(non DBO or SSO\): 0 - None, 1 - Disable, 2 - Delete if possible,;\
    echo \#\# 3 - Delete if possible, otherwise disable. Default is 0 \(you can leave this unset\);\
    echo \# set disableDeleteUsers =;\
    echo ;\
   '

   
   
################################################################################   
## CMD LINE PROCESSING
##
         
# posible switches
set switches_with_arg = 'oracleSid sysPasswdFile dboUserId origDboUserId dboPassword ssoPassword ssoUserId backupDir backupFile configFile tableSpaceDir tablespaceType encryptionPassword disableDeleteUsers printConfig'
set no_arg_switches   = 'doExport doImport dateOnly'

#unset all switches so we don't pick up something
unset_all

# process cmd line args
while ($#argv != 0)
    if ("$argv[1]" !~ -*) then
        echo
        echo ERROR Bad cmd line argument: $argv[1]
        echo
        print_usage
        exit 1
    endif
    
    # remove '-' char and check the switch
    set variable_name = `echo $argv[1] | sed "s/\-//"`

    unset switch_processed
    set temp = ${variable_name}
    foreach x (${switches_with_arg})
        set temp = `echo ${temp} | sed "s/$x//"`
    end
    set temp = `echo ${temp} | sed "s/./\#/g"`
    if ( ${temp} !~ \#* && $#argv != 1) then
        if ("$argv[2]" !~ \-*) then 
            set ${variable_name} = $argv[2]
            shift
            shift
            set switch_processed
        endif
    endif

    set temp = ${variable_name}
    foreach x (${no_arg_switches})
        set temp = `echo ${temp} | sed "s/$x//"`
    end
    set temp = `echo ${temp} | sed "s/./\#/g"`
    if ( ${temp} !~ \#* ) then
        set ${variable_name}
        shift
        set switch_processed
    endif

    if ( ! $?switch_processed ) then
        echo
        echo ERROR: Bad usage or bad switch: $argv[1]
        echo
	print_usage
        exit 1
    endif
end

# One of the following must be specified: doExport, doImport, printConfig or configFile
if (! $?doExport && ! $?doImport && ! $?printConfig && ! $?configFile) then
    print_usage
    exit 0
endif

# If printConfig option is on, just print the config file template
if ($?printConfig) then
    if ($printConfig  == export) then
	print_config_file_template_export
    else if ($printConfig == import) then
	print_config_file_template_import
    else
        echo
        echo ERROR: Bad printConfig usage!
        echo
	print_usage
	exit 1
    endif
    exit 0
endif    

# If config file is given as the command line argument
if ($?configFile) then
    set configFileName = ${configFile}
    if (-f ${configFile} && -r ${configFile}) then
        unset_all
        source "${configFileName}"
    else
        echo
        echo ERROR: Cannot read config file: "${configFileName}"
        echo
        exit 1
    endif
endif

# we don't want to run export and import at once
if ($?doExport && $?doImport) then
    echo
    echo ERROR: both doExport and doImport switches are on. You can only use one of them.
    echo
    exit 1
endif    

################################################################################
## START
##

clear
echo
echo "$0 start..."
echo

################################################################################
## CHECK VARIABLES
##

# Check export parameters
if ($?doExport) then
    if (! $?oracleSid) then
        echo
        echo ERROR: Oracle SID \(oracleSid\) of the server is missing.
        echo
        print_usage
        exit 1
    endif
    if (! $?sysPasswdFile) then
        echo
        echo SYS password \(sysPasswdFile\) is not specified.
        echo Skipped GRANT read, write ON DIRECTORY DBDUMPS TO ${dboUserId}
        echo
    else
        if (! -r ${sysPasswdFile}) then
            echo
            echo ERROR: Cannot read file ${sysPasswdFile}
            echo
            print_usage
            exit 1
        endif
        if (-P077 ${sysPasswdFile}) then
            echo
            echo ERROR: Other users must have NO PERMISSIONS on the password file - ${sysPasswdFile}
            echo
            print_usage
            exit 1
        endif
        set sysPassword = `cat $sysPasswdFile`
    endif
    if (! $?dboUserId) then
        echo
        echo ERROR: DBO export user \(dboUserId\) is missing.
        echo
        print_usage
        exit 1
    endif
    if (! $?dboPassword) then
        echo
        echo ERROR: DBO export user password \(dboPassword\) is missing.
        echo
        print_usage
        exit 1
    endif
    if (! $?backupDir) then
        echo
        echo ERROR: Backup directory \(backupDir\) for export is missing.
        echo
        print_usage
        exit 1
    endif
    if (! $?encryptionPassword) then
        set CMDencryptionPassword = 
    else
        set CMDencryptionPassword = ENCRYPTION_PASSWORD=${encryptionPassword}
    endif

    if ($?dateOnly) then
	set timeStamp = `date +'%Y-%m-%d'`
    endif
    # set dump file name for export
    set exportDumpFile = ${dboUserId}.${timeStamp}.dmp
    
endif

# Check import paramters
if ($?doImport) then
    if (! $?oracleSid) then
        echo
        echo ERROR: Oracle SID \(oracleSid\) of is missing.
        echo
        print_usage
        exit 1
    endif
    
    if (! $?sysPasswdFile) then
        echo
        echo SYS password \(sysPasswdFile\) is not specified.
        echo Skipped SYS operations and used DBO for import. It is assuming that 
        echo tablespace, user/schema, and directory privilege were already created by SYS.
        echo
        # Need to be empty for CreateDboSsoAndFixUsers.sh script
        set sysPassword = ""
    else
        if (! -r ${sysPasswdFile}) then
            echo
            echo ERROR: Cannot read file: ${sysPasswdFile}
            echo
            print_usage
            exit 1
        endif
        if (-P077 ${sysPasswdFile}) then
            echo
            echo ERROR: Other users must have NO PERMISSIONS on the password file - ${sysPasswdFile}
            echo
            print_usage
            exit 1
        endif
        set sysPassword = `cat $sysPasswdFile`
    endif
    
    if (! $?dboUserId) then
        echo
        echo ERROR: DBO import user \(dboUserId\) is missing.
        echo
        print_usage
        exit 1
    endif
    
    if (! $?dboPassword) then
        echo
        echo ERROR: DBO import user password \(dboPassword\) is missing.
        echo
        print_usage
        exit 1    
    endif
    
    if (! $?origDboUserId) then
        echo
        echo ERROR: Original DBO  user \(origDboUserId\) is missing.
        echo
        print_usage
        exit 1
    endif
    
    if (! $?ssoUserId) then
	set ssoUserId = ${dboUserId}SSO
        echo
        echo SSO user not specified - using ${dboUserId}SSO
        echo
    endif
    
    if (! $?ssoPassword) then
        echo
        echo ERROR: New SSO user password \(ssoPassword\) is missing.
        echo
        print_usage
        exit 1    
    endif
    
    if (! $?backupDir) then
        echo
        echo ERROR: Backup directory \(backupDir\) for import is missing.
        echo
        print_usage
        exit 1
    endif

    if (! $?backupFile) then
	echo
	echo ERROR: Backup file \(backupFile\) for import is missing.
	echo
	print_usage
	exit 1
    endif

    # replace percentage character if in, with a date
    set timeStamp = `date +'%Y-%m-%d'`
    set backupFile = `echo $backupFile | sed "s/\%/$timeStamp/g"`
    
    if (! $?tableSpaceDir) then
        echo
        echo ERROR: Tablespace directory \(tableSpaceDir\) is missing.
        echo
        print_usage
        exit 1
    endif
    # Make sure path ends with slash
    set tableSpaceDir = `echo ${tableSpaceDir}/ | sed "s/\/\+/\//g"`
    
    if (! $?tablespaceType) then
        set tablespaceType = " "
    endif

    if (! $?encryptionPassword) then
        set CMDencryptionPassword = 
    else
        set CMDencryptionPassword = ENCRYPTION_PASSWORD=${encryptionPassword}
    endif

    if (! $?disableDeleteUsers) then
        # set default value
        set disableDeleteUsers = 0
    endif
    if (${disableDeleteUsers} < 0 || ${disableDeleteUsers} > 3) then
        echo
        echo ERROR: Bad disableDeleteUsers value: ${disableDeleteUsers}
        echo
        print_usage
        exit 1
    endif
endif


# Touch the output file and put all the values in
echo >! ${SCRIPT_OUTPUT_FILE}

echo The following values are being used:  >>& ${SCRIPT_OUTPUT_FILE}
echo ===================================== >>& ${SCRIPT_OUTPUT_FILE}
foreach x (${no_arg_switches})
    set defined = '$?'${x}
    set not_defined = '! ''$?'${x}
    eval " \
      if ($defined) then \
        echo ${x} - set >>& ${SCRIPT_OUTPUT_FILE} \
      else \
        echo ${x} - not set >>& ${SCRIPT_OUTPUT_FILE} \
      endif \
         "
end

echo >>& ${SCRIPT_OUTPUT_FILE}

foreach x (${switches_with_arg})
    set defined = '$?'${x}
    set not_defined = '! ''$?'${x}
    set value   = '$'${x}
    eval " \
      if ($defined) then \
        echo ${x} - set >>& ${SCRIPT_OUTPUT_FILE} \
      else \
        echo ${x} - not set >>& ${SCRIPT_OUTPUT_FILE} \
      endif \
         "
end

echo ===================================== >>& ${SCRIPT_OUTPUT_FILE}
echo >>& ${SCRIPT_OUTPUT_FILE}

################################################################################
## EXPORT
##
# If doExport is defined...
if ($?doExport) then 
    echo ${timeStamp} - Exporting ${dboUserId}${oracleSid}
    echo ${timeStamp} - Exporting ${dboUserId}${oracleSid} >>& ${SCRIPT_OUTPUT_FILE}

    if ($?sysPasswdFile) then

        # Execute as SYS Oracle user:
        echo -n "Grant read/write privileges on backup directory..."
        sqlplus -S -L /NOLOG <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        CONNECT SYS/${sysPassword}@${oracleSid} AS SYSDBA
            --CREATE OR REPLACE DIRECTORY SIERRA_BACKUPDIR AS '${backupDir}'; 
            GRANT READ, WRITE ON DIRECTORY ${backupDir} TO ${dboUserId};
            EXIT;
EOF
        check_exit_code
        echo " done!"
    endif

    # Call expdp to dump DB backup
    echo -n "Calling expdp to dump DB (this might take some time)..."
#    expdp ${dboUserId}@${oracleSid} VERSION=11.2 DIRECTORY=${backupDir} DUMPFILE=${exportDumpFile} LOGFILE=${exportDumpFile}.export.log SCHEMAS=${dboUserId} COMPRESSION=ALL ${CMDencryptionPassword} <<EOF >>& ${SCRIPT_OUTPUT_FILE}
#        ${dboPassword}
#EOF
    expdp ${dboUserId}/${dboPassword}@${oracleSid} VERSION=11.2 DIRECTORY=${backupDir} DUMPFILE=${exportDumpFile} LOGFILE=${exportDumpFile}.export.log SCHEMAS=${dboUserId} COMPRESSION=ALL ${CMDencryptionPassword} >>& ${SCRIPT_OUTPUT_FILE}
    check_exit_code
    echo " done!"

endif


################################################################################
## IMPORT
##
if ($?doImport) then
    echo ${timeStamp} - Importing ${dboUserId}${oracleSid}
    echo ${timeStamp} - Importing ${dboUserId}${oracleSid} >>& ${SCRIPT_OUTPUT_FILE}

    # Check if reglogin.info file already exists
    if (-e reglogin.info.${dboUserId}) then
	echo
        echo ERROR: reglogin.info.${dboUserId} file already exists!
	echo Please \(re\)move it and run the script again. Thanks.
        echo
        exit 1
    endif
    
    if ($?sysPasswdFile) then
        ##########################
        ## All connections for this user on the DB must be closed
        echo -n "Disconnecting all users from the ${dboUserId} schema..."
        sqlplus -S -L /NOLOG <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        CONNECT SYS/${sysPassword}@${oracleSid} AS SYSDBA
        SET SERVEROUTPUT ON
        BEGIN
            FOR SESSION_RECORD IN (SELECT SID, SERIAL# FROM V\$SESSION WHERE UPPER(SCHEMANAME) = UPPER('${dboUserId}'))
            LOOP
                BEGIN
                    EXECUTE IMMEDIATE ('ALTER SYSTEM KILL SESSION ' || '''' || SESSION_RECORD.SID || ',' || SESSION_RECORD.SERIAL# || '''');
                END;
            END LOOP;
        END;
        /
EOF
        echo " done!"

        ##########################
        ## Drop schema if there and create it again
        echo -n "Dropping ${dboUserId} user, tablespace ${dboUserId}_TS and ${dboUserId}_ROLE if there already..."
        sqlplus -S -L /NOLOG <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        CONNECT SYS/${sysPassword}@${oracleSid} AS SYSDBA 
            DROP USER ${dboUserId} CASCADE;
            DROP ROLE ${dboUserId}_ROLE;
            DROP TABLESPACE ${dboUserId}_TS INCLUDING CONTENTS AND DATAFILES;
            EXIT;
EOF
        check_exit_code
        echo " done!"

        ##########################
        ## Create new Schema
        echo -n "Creating new schema ${dboUserId}, tablespace, ${dboUserId}_ROLE..."
        sqlplus -S -L /NOLOG <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        CONNECT SYS/${sysPassword}@${oracleSid} AS SYSDBA
            CREATE ${tablespaceType} TABLESPACE ${dboUserId}_TS DATAFILE '${tableSpaceDir}/${dboUserId}_TS.dbf' SIZE 100M AUTOEXTEND ON NEXT 100M EXTENT MANAGEMENT LOCAL;
            CREATE USER ${dboUserId} IDENTIFIED BY "${dboPassword}" DEFAULT TABLESPACE ${dboUserId}_TS
                   TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK; 
            GRANT read, write ON DIRECTORY ${backupDir} TO ${dboUserId};
            CREATE ROLE ${dboUserId}_ROLE;
            GRANT ${dboUserId}_ROLE TO ${dboUserId} WITH ADMIN OPTION;
            GRANT SELECT_CATALOG_ROLE TO ${dboUserId}  WITH ADMIN OPTION;
            GRANT CREATE TABLE TO ${dboUserId} WITH ADMIN OPTION;
            GRANT CREATE SESSION TO ${dboUserId} WITH ADMIN OPTION;
            GRANT CREATE PROCEDURE TO ${dboUserId};
            GRANT CREATE USER TO ${dboUserId};
            GRANT ALTER USER TO ${dboUserId};
            GRANT CREATE ROLE TO ${dboUserId};
            GRANT CREATE SEQUENCE TO ${dboUserId};
            GRANT CREATE SYNONYM TO ${dboUserId};
            GRANT UNLIMITED TABLESPACE TO ${dboUserId};
            GRANT CREATE ANY TRIGGER TO ${dboUserId};
            GRANT CREATE VIEW TO ${dboUserId};
            GRANT ALTER SESSION TO ${dboUserId};
            GRANT DROP USER TO ${dboUserId};
            GRANT EXECUTE ANY PROCEDURE TO ${dboUserId};
            GRANT SELECT ON SYS.DBA_ROLE_PRIVS TO ${dboUserId};
            GRANT SELECT ON SYS.DBA_SYS_PRIVS TO ${dboUserId};
            GRANT READ ON DIRECTORY ${backupDir} TO ${dboUserId};
            EXIT;
EOF
        check_exit_code
        echo " done!"

        # Call impdp to load 
        echo -n "Calling impdp to import data into new schema (this might take some time)..."
# This is not working on Oracle 19c - Password must be specified
#        impdp \"SYS@${oracleSid} AS SYSDBA\" DIRECTORY=${backupDir} DUMPFILE=${backupFile} LOGFILE=${backupFile}.import.log SCHEMAS=${origDboUserId} remap_schema=${origDboUserId}:${dboUserId} REMAP_TABLESPACE=${origDboUserId}_TS:${dboUserId}_TS content=ALL TABLE_EXISTS_ACTION=REPLACE ${CMDencryptionPassword} <<EOF >>& ${SCRIPT_OUTPUT_FILE}
#            ${sysPassword}
#EOF
        impdp \"SYS/${sysPassword}@${oracleSid} AS SYSDBA\" DIRECTORY=${backupDir} DUMPFILE=${backupFile} LOGFILE=${backupFile}.import.log SCHEMAS=${origDboUserId} remap_schema=${origDboUserId}:${dboUserId} REMAP_TABLESPACE=${origDboUserId}_TS:${dboUserId}_TS content=ALL TABLE_EXISTS_ACTION=REPLACE ${CMDencryptionPassword} >>& ${SCRIPT_OUTPUT_FILE}
        check_exit_code
        echo " done!"

    else
        # No SYS pwd, import using DBO
    
        ##########################
        ## Drop Sierra schema OBJECTS, keeps schema itself
        echo -n "Dropping Sierra ${dboUserId} schema OBJECTS, keeps schema ..."
        sqlplus -S -L /NOLOG <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        CONNECT ${dboUserId}/${dboPassword}@${oracleSid}
        SET SERVEROUTPUT ON SIZE 1000000;
        DECLARE
          sqlstr     VARCHAR2(250);
          numErrors  INT := 0;
        BEGIN
          FOR rec IN (
            SELECT table_name, constraint_name 
            FROM user_constraints 
            WHERE constraint_type = 'R'
          )
          LOOP
            BEGIN
              sqlstr := 'ALTER TABLE ' || rec.table_name || ' drop constraint ' || rec.constraint_name;
              EXECUTE IMMEDIATE sqlstr;
            EXCEPTION WHEN OTHERS THEN 
              DBMS_OUTPUT.PUT_LINE('Failed: ' || sqlstr || ' because of ' || SQLERRM);
              numErrors := numErrors + 1;
            END;
          END LOOP;

          FOR rec IN (
            SELECT object_name, object_type
            FROM user_objects 
            WHERE object_type IN ('FUNCTION', 'PACKAGE', 'PROCEDURE', 'SEQUENCE', 'TABLE', 'VIEW')
            ORDER BY object_type, object_name
          )
          LOOP
            BEGIN
              sqlstr := 'DROP ' || rec.object_type || ' ' || rec.object_name;
              EXECUTE IMMEDIATE sqlstr;
            EXCEPTION WHEN OTHERS THEN 
              DBMS_OUTPUT.PUT_LINE('Failed: ' || sqlstr || ' because of ' || SQLERRM);
              numErrors := numErrors + 1;
            END;
          END LOOP;

          BEGIN
            sqlstr := 'DROP ROLE ${dboUserId}_ROLE';
            -- Made by SYS
            -- EXECUTE IMMEDIATE sqlstr;
          EXCEPTION WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Failed: ' || sqlstr || ' because of ' || SQLERRM);
            numErrors := numErrors + 1;
          END;

          IF numErrors = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Dropping old objects - No errors');
          ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Cannot drop all objects - Num. error(s): ' || numErrors);
          END IF;  
        END;
        /
        EXIT;
EOF
        check_exit_code
        echo " done!"
        echo -n "Calling impdp to import data into new schema (this might take some time)..."
        impdp ${dboUserId}@${oracleSid} DIRECTORY=${backupDir} DUMPFILE=${backupFile} LOGFILE=${backupFile}.import.log SCHEMAS=${origDboUserId} remap_schema=${origDboUserId}:${dboUserId} REMAP_TABLESPACE=${origDboUserId}_TS:${dboUserId}_TS content=ALL TABLE_EXISTS_ACTION=REPLACE ${CMDencryptionPassword} <<EOF >>& ${SCRIPT_OUTPUT_FILE}
            ${dboPassword}
EOF
        check_exit_code
        echo " done!"

    endif
    
    # Call CreateDboSsoAndFixUsers.sh script
    echo -n "Calling CreateDboSsoAndFixUsers.sh..."
    CreateDboSsoAndFixUsers.sh -T O -S ${oracleSid} -D ${dboUserId} -U ${dboUserId} -P ${dboPassword} -u ${ssoUserId} -p ${ssoPassword} <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        ${sysPassword}
        ${disableDeleteUsers}
        y
EOF
    check_exit_code
    echo " done!"

    # Set toggles
    echo -n "Set the toggle values properly..."
    sqlplus -S -L /NOLOG <<EOF >>& ${SCRIPT_OUTPUT_FILE}
    CONNECT ${dboUserId}/${dboPassword}@${oracleSid}
        alter trigger updsydefault disable;
        alter trigger updsbdefault disable;
  
        -- CPLIMSRV - TODO: Check if we still need this?
        -- CPLIMSRV option_list settings should look like 'OFF                      localhost 35008'
        -- update sydefault set option_list = 'OFF                      localhost \$\{portPrefix\}08' where config_code = 'CPLIMSRV';
        -- update sbdefault set option_list = 'OFF                      localhost \$\{portPrefix\}08' where config_code = 'CPLIMSRV';
        -- update sydefault set cur_setting = 1 where config_code = 'CPLIMSRV' and cur_setting != 0;
        -- update sbdefault set cur_setting = 1 where config_code = 'CPLIMSRV' and cur_setting != 0;

        -- Set Reuters DACS ID Toggle option_list settings should look like '142                      520'
        -- update sydefault set option_list = '142                      \$\{portPrefix\}', cur_setting = 2 where config_code = 'DACS ID';
        -- update sbdefault set option_list = '142                      \$\{portPrefix\}', cur_setting = 2 where config_code = 'DACS ID';
  
        -- GETNAME
        update sydefault set cur_setting = 1, max_setting = 2, option_list = 'New Install              ${dboUserId}' where config_code = 'GETNAME'; 
        update sbdefault set cur_setting = 1, max_setting = 2, option_list = 'New Install              ${dboUserId}' where config_code = 'GETNAME'; 
  
        alter trigger updsydefault enable;
        alter trigger updsbdefault enable;
        exit;
EOF
    check_exit_code
    echo " done!"
    # Call CreateDboSsoAndFixUsers.sh script agian
    echo -n "Calling CreateDboSsoAndFixUsers.sh again in case triggers or FKs were not set up correctly ..."
    CreateDboSsoAndFixUsers.sh -T O -S ${oracleSid} -D ${dboUserId} -U ${dboUserId} -P ${dboPassword} -u ${ssoUserId} -p ${ssoPassword} <<EOF >>& ${SCRIPT_OUTPUT_FILE}
        ${sysPassword}
        ${disableDeleteUsers}
        y
EOF
    echo " done!"
endif


################################################################################
## REGLOGIN.INFO CREATION
##
# Create reglogin.info file
if ($?doImport) then
    echo -n "Create reglogin.info.${dboUserId} file... "
    echo -n "${oracleSid}	${dboUserId}	${dboUserId}	" > reglogin.info.${dboUserId}
    check_exit_code
    ${FNXROOT}/bin/aspencrypt ${dboPassword} >> reglogin.info.${dboUserId}
    check_exit_code
    echo " done!"
endif    

if (-e $SCRIPT_OUTPUT_FILE) then
    echo
    echo Done!
    echo Check $SCRIPT_OUTPUT_FILE for more info on possible errors.
    echo
endif    