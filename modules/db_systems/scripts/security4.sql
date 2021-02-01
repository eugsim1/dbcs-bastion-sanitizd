spool admin1.txt
show user; 

show parameter processes
alter system set processes = 505 scope=memory;

select * from v$parameter where name like '%optimizer_index%';
alter system set optimizer_index_cost_adj = 85 scope=memory;

--
-- Basic actions a DBA or end-user might take. 
-- Review this data in Data Safe, does it get audited if it is successful or not? Is it important? 
-- ALTER TABLE of the HCM_USER objects should not fail. 
--
alter table HCM1.employees modify phone_number varchar2(20); 

--
-- Basic actions a DBA or end-user might take. 
-- Review this data in Data Safe, does it get audited if it is successful or not? Is it important? 
-- Grant/Revoke commands might fail.  This is acceptable behavior
--
grant select any table to scott;
revoke select any table from scott;
grant select any table to approle2;
column Grant_Gen format a25
select null as "Grant_Gen" from dual;
spool off
