spool part1.txt
show user;
drop package TICKETINFO_PKG;
drop public synonym TICKETINFO_PKG;
drop context TICKETINFO;
grant execute on dbms_ldap to SECURE_STEVE with grant option;

create context TICKETINFO using TICKETINFO_PKG;

create or replace package TICKETINFO_PKG as

    procedure set_value_in_context(p_value in varchar2);

end TICKETINFO_PKG;
/

create or replace package body TICKETINFO_PKG as

    procedure set_value_in_context(p_value in varchar2) is
    begin
         dbms_session.set_context('TICKETINFO', 'TICKET_ID', p_value);
      end set_value_in_context;

 end TICKETINFO_PKG;
 /

grant execute on ticketinfo_pkg to public;

create public synonym TICKETINFO_PKG for TICKETINFO_PKG;

AUDIT CONTEXT NAMESPACE TICKETINFO ATTRIBUTES TICKET_ID;


NOAUDIT POLICY app_user_not_app_server;
DROP AUDIT POLICY app_user_not_app_server;
--
CREATE AUDIT POLICY app_user_not_app_server
  ACTIONS ALL
     WHEN 'SYS_CONTEXT(''USERENV'', ''SESSION_USER'') in (''APP_USER'',''HCM1'') AND SYS_CONTEXT(''USERENV'', ''CLIENT_PROGRAM_NAME'') != ''AppServer@AUTONOMOUS (TNS V1-V3)'''
 EVALUATE PER SESSION;

-- do not enable this until the workshop lab
--AUDIT POLICY app_user_not_app_server;

-- Create a Unified Audit Policy to audit whenever PU_PETE SELECTs data from an "HCM" table called "EMPLOYEES"
NOAUDIT POLICY EMPSEARCH_SELECT_USAGE_BY_PETE;
DROP AUDIT POLICY EMPSEARCH_SELECT_USAGE_BY_PETE;
--
CREATE AUDIT POLICY EMPSEARCH_SELECT_USAGE_BY_PETE
     ACTIONS SELECT ON HCM1.EMPLOYEES                 
        WHEN 'SYS_CONTEXT(''USERENV'',''SESSION_USER'') = ''PU_PETE'''
    EVALUATE PER SESSION;
AUDIT POLICY EMPSEARCH_SELECT_USAGE_BY_PETE; 

NOAUDIT POLICY EMP_RECORD_CHANGES;
DROP AUDIT POLICY EMP_RECORD_CHANGES;
--
create audit policy EMP_RECORD_CHANGES
  ACTIONS INSERT ON HCM1.EMPLOYEES
        , INSERT ON HCM1.EMP_EXTENDED
        , UPDATE ON HCM1.EMPLOYEES
        , UPDATE ON HCM1.EMP_EXTENDED
	    , DELETE ON HCM1.EMPLOYEES
        , DELETE ON HCM1.EMP_EXTENDED
     WHEN 'SYS_CONTEXT(''USERENV'', ''SESSION_USER'') != ''HCM1'''
 EVALUATE PER SESSION;
AUDIT POLICY EMP_RECORD_CHANGES;



-- Some of these may fail if you are on ADB.  That is acceptable. 
AUDIT POLICY ORA_DV_AUDPOL2;
AUDIT POLICY ORA_CIS_RECOMMENDATIONS;
AUDIT POLICY ORA_ACCOUNT_MGMT;
AUDIT POLICY ORA_DATABASE_PARAMETER;
AUDIT POLICY DP_ACTIONS_POL;
AUDIT POLICY ORA_LOGON_FAILURES;
AUDIT POLICY ORA_DV_AUDPOL;
AUDIT POLICY ORA_SECURECONFIG;
AUDIT POLICY ORA_RAS_SESSION_MGMT;
AUDIT POLICY ORA_RAS_POLICY_MGMT;

column DBA_Queries3 format a25
select null as "DBA_Queries3" from dual;
exec dbms_stats.gather_table_stats('HCM1','EMPLOYEES');

column DBA_Queries4 format a25
select null as "DBA_Queries4" from dual;
alter system switch logfile;  


column DBA_Queries5 format a25
select null as "DBA_Queries5" from dual;

select count(*) From v$session;
select * from gv$instance;
select count(*) from v$process;
select sessions_max, sessions_current, sessions_highwater, users_max from v$license;

select b.paddr , b.name nme, b.description descr, to_char(b.error) cerror from  v$bgprocess b, v$process p where  b.paddr = p.addr;

select sequence#, group#, first_change#, first_time, archived, bytes from v$log order by sequence#, group#;

select count(*)
from sys.dba_segments a
where a.tablespace_name not like 'T%MP%'
   and nvl(a.next_extent,a.initial_extent) * 1 > 
    (select max(b.bytes) from dba_free_space b where a.tablespace_name = b.tablespace_name);


SELECT count(*)
FROM (SELECT tablespace_name, SUM (blocks) ublocks
        FROM dba_segments
        GROUP BY tablespace_name) s,
     (SELECT tablespace_name, SUM (blocks) fblocks
        FROM dba_free_space
        GROUP BY tablespace_name) f,
     (SELECT tablespace_name, SUM(blocks) ablocks
        FROM dba_data_files
        GROUP BY tablespace_name) a
WHERE s.tablespace_name = f.tablespace_name and
      s.tablespace_name = a.tablespace_name and
      s.tablespace_name not in ('SYSTEM','SYSAUX','TOOLS','UNDO01') and
      ((s.ublocks/a.ablocks)*100) > 50;
spool off