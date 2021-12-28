-- A Simple Function-Based Index Example

drop table emp purge;

set echo on

create table emp
as
select *
from scott.emp
where 1=0;

insert into emp
(empno,ename,job,mgr,hiredate,sal,comm,deptno)
select rownum empno,
initcap(substr(object_name,1,10)) ename,
substr(object_type,1,9) JOB,
rownum MGR,
created hiredate,
rownum SAL,
rownum COMM,
(mod(rownum,4)+1)*10 DEPTNO
from all_objects
where rownum < 10000;

create index emp_upper_idx on emp(upper(ename));

begin
     dbms_stats.gather_table_stats
     (user,'EMP',cascade=>true);
end;
/

set lines 132
set autotrace traceonly explain

select *
from emp
where upper(ename) = 'KING';

set autotrace off
set lines 80
