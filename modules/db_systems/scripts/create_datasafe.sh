#!/bin/bash
export serverFQDN=`hostname -f` 
echo $serverFQDN
export domainFQDN=`hostname -d` 
echo $domainFQDN
##export server=$DB_NAME
export ORACLE_HOSTNAME=$serverFQDN
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19.0.0/dbhome_1
export ORA_INVENTORY=/u01/app/oraInventory
#export ORACLE_SID=$server
export DATA_DIR=/u01/app/oracle/oradata19
export PATH=/usr/sbin:/usr/local/bin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export TNS_ADMIN=$ORACLE_HOME/network/admin
export DB_NAME=ggsrc
export PDB1=pdb1src

cd $TNS_ADMIN
echo "start script" > /home/oracle/scripts/datasafe_log.txt
lsnrctl stop >> /home/oracle/scripts/datasafe_log.txt

cp tnsnames.ora tnsnames.ora-ORIGINAL
cp tns_names_template tnsnames.ora

sed "s/\$server/$serverFQDN/g" -i tnsnames.ora
sed "s/\$domain/$domainFQDN/g" -i tnsnames.ora
sed "s/\$dbname/$DB_NAME/g" -i tnsnames.ora
cat tnsnames.ora  >> /home/oracle/scripts/datasafe_log.txt

cp listener.ora listener.ora-bck
cp listener_template.ora listener.ora
sed "s/\$server/$serverFQDN/g" -i listener.ora
sed "s/\$domain/$domainFQDN/g" -i listener.ora
sed "s/\$dbname/$DB_NAME/g" -i listener.ora

cat listener.ora
#cat listener.ora sid_add.txt > listerner_static.ora
#cp listener.ora listener.ora-backup
#mv listerner_static.ora  listener.ora

lsnrctl start
lsnrctl status >> /home/oracle/scripts/datasafe_log.txt

sleep 60s

cd /home/oracle/scripts

echo ${DB_NAME}

sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba <<EOF
drop USER C##DATASAFE_ADMIN cascade;
CREATE USER C##DATASAFE_ADMIN identified by "WElcome1412#!" container=all
default tablespace users
temporary tablespace temp
quota unlimited on users;
GRANT CONNECT, RESOURCE TO  C##DATASAFE_ADMIN;
EOF

sqlplus  sys/'BEstrO0ng_#12'@$DB_NAME as sysdba <<EOF 
SET PAGESIZE 0;
col username format a20
SELECT distinct username, con_id FROM cdb_users
WHERE username='C##DATASAFE_ADMIN';
EOF


sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba <<EOF  
SET PAGESIZE 0;
select * from dba_users
EOF


sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba <<EOF 
SET PAGESIZE 0;
select username from dba_users order by username asc;
EOF


sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba<<EOF 
alter session set container=$PDB1;
drop USER DATASAFE_ADMIN cascade;
CREATE USER DATASAFE_ADMIN identified by "WElcome1412#!" 
default tablespace users
temporary tablespace temp
quota unlimited on users;
GRANT CONNECT, RESOURCE TO DATASAFE_ADMIN;
EOF

cd /home/oracle/scripts
sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba <<EOF	 
alter session set container=$PDB1;
@dscs_privileges.sql  DATASAFE_ADMIN GRANT ALL -VERBOSE

grant ROLE 'ASSESSMENT' to  DATASAFE_ADMIN;
grant ROLE 'AUDIT_COLLECTION' to  DATASAFE_ADMIN;;
grant ROLE 'DATA_DISCOVERY' to  DATASAFE_ADMIN;;
grant ROLE 'DATA_MASKING' to  DATASAFE_ADMIN;;
grant ROLE 'AUDIT_SETTING' to  DATASAFE_ADMIN;;
EOF

 
sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba <<EOF  
alter session set container=$PDB1;
drop USER OE cascade;
CREATE USER OE identified by "WElcome1412#!" 
default tablespace users
temporary tablespace temp
quota unlimited on users;
GRANT CONNECT, RESOURCE TO OE;
EOF

sqlplus  C##DATASAFE_ADMIN/'WElcome1412#!'@$DB_NAME<< EOF  
exit;
EOF



sqlplus  OE/'WElcome1412#!'@$PDB1 << EOF  
exit;
EOF

cd /home/oracle/scripts
rm -rf *zip*
rm -rf ../swingbench
wget http://www.dominicgiles.com/swingbench/swingbench261076.zip
unzip -d .. swingbench261076.zip





cd ../swingbench/bin
./oewizard -cl -create -cs //localhost/$PDB1.${domainFQDN} -scale "0.3" -u OE -p 'WElcome1412#!' -ts users -tc 7 -v   -dba 'sys as sysdba' -dbap BEstrO0ng_#12 


#Cloning PDB Within the Same CDB

sqlplus sys/'BEstrO0ng_#12'@$DB_NAME as sysdba << EOF  
alter pluggable database $PDB1 close;
alter pluggable database $PDB1 open read only;
alter system set db_create_file_dest = '/u02/app/oracle/oradata/pdb2';
CREATE PLUGGABLE DATABASE pdb2 FROM $PDB1 KEYSTORE IDENTIFIED BY "BEstrO0ng_#12";

select name, open_mode from v\$pdbs;
alter pluggable database PDB2 close;
alter pluggable database $PDB1 close;
alter pluggable database PDB2 open;
alter pluggable database $PDB1 open;
col name format A50
select name, con_id from v\$services;
EOF

sqlplus oe/'WElcome1412#!'@$PDB1 << EOF  
exit;
EOF