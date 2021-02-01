spool DEB_DEBRA.txt
show user;

select count(*)
from    v$sysstat a, v$statname b
where   a.statistic# = b.statistic#;

select sum(getmisses)/sum(gets)*100 dict_cache from v$rowcache;

select sum(reloads)/sum(pins) *100 lib_cache from v$librarycache;
spool off
connect DBA_HARVEY/MY_PASSWORD@AUTONOMOUS
spool DBA_HARVEY.txt
show user;

select  count(*)
from   v$sysstat
where  name in ('sorts (memory)', 'sorts (disk)','sorts (rows)');

select   count(*)
from	v$sysstat
where   name = 'free buffer waits';

SELECT  count(*)
FROM	v$system_event SE,
	(SELECT SUM(time_waited) total_waittime FROM v$system_event
	WHERE wait_class NOT IN ('Idle','Network'))
WHERE	total_waits > 0
	AND time_waited > 1000
	AND wait_class NOT IN ('Idle','Network');
	
column DBA_Queries6 format a25
select null as "DBA_Queries6" from dual;	
begin 
for x in (select owner, index_name from dba_indexes where owner = 'HCM1) loop

begin
dbms_output.put_line('rebuilding '||x.owner||'.'||x.index_name||'...');
execute immediate 'alter index '||x.owner||'.'||x.index_name||' rebuild';
exception when others then
 null;
end;

end loop;
end;
/

grant select on HCM1.EMPLOYEES to PU_PETE;
grant select on HCM1.EMP_EXTENDED to PU_PETE;
grant select on HCM1.LOCATIONS to PU_PETE;

column Regular_Work4 format a25
select null as "Regular_Work4" from dual;
spool off