spool PU_PETE.txt
show user;

select FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID from HCM1.EMPLOYEES where employee_id = 183 order by last_name;

select FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID from HCM1.EMPLOYEES where department_id = 183 order by last_name;

select FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, SALARY,COMMISSION_PCT,MANAGER_ID from HCM1.EMPLOYEES where department_id = &DEPT_ID order by manager_id;

UPDATE HCM1.EMPLOYEES set COMMISSION_PCT = 37 where EMP_ID = 183;

select * from HCM1.emp_extended where employee_id = 183;

select * from HCM1.locations where location_id = &LOC_ID;

select LAST_NAME, FIRST_NAME, EMAIL from HCM1.employees where manager_id = 183; order by 2;

column DBA_Work1 format a25
select null as "DBA_Work1" from dual;
spool off
