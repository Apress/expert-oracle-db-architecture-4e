-- Index Organized Tables, example 1

drop table heap_addresses purge;
drop table iot_addresses purge;
drop table emp purge;

set echo on

create table emp
as
select object_id empno,
object_name      ename,
created          hiredate,
owner            job
from all_objects
/

alter table emp add constraint emp_pk primary key(empno);

begin
  dbms_stats.gather_table_stats( user, 'EMP', cascade=>true );
end;
/

create table heap_addresses
( empno     references emp(empno) on delete cascade,
  addr_type varchar2(10),
  street    varchar2(20),
  city      varchar2(20),
  state     varchar2(2),
  zip       number,
  primary key (empno,addr_type)
)
/

create table iot_addresses
  ( empno     references emp(empno) on delete cascade,
    addr_type varchar2(10),
    street    varchar2(20),
    city      varchar2(20),
    state     varchar2(2),
    zip       number,
    primary key (empno,addr_type)
  )
ORGANIZATION INDEX
/

--------------------------------------
insert into heap_addresses
  select empno, 'WORK', '123 main street', 'Washington', 'DC', 20123
  from emp;

insert into iot_addresses
  select empno, 'WORK', '123 main street', 'Washington', 'DC', 20123
  from emp;
--------------------------------------
insert into heap_addresses
  select empno, 'HOME', '123 main street', 'Washington', 'DC', 20123
  from emp;

insert into iot_addresses
  select empno, 'HOME', '123 main street', 'Washington', 'DC', 20123
  from emp;
--------------------------------------
insert into heap_addresses
  select empno, 'PREV', '123 main street', 'Washington', 'DC', 20123
  from emp;

insert into iot_addresses
  select empno, 'PREV', '123 main street', 'Washington', 'DC', 20123
  from emp;
--------------------------------------
insert into heap_addresses
  select empno, 'SCHOOL', '123 main street', 'Washington', 'DC', 20123
  from emp;

insert into iot_addresses
  select empno, 'SCHOOL', '123 main street', 'Washington', 'DC', 20123
  from emp;
--------------------------------------
exec dbms_stats.gather_table_stats( user, 'HEAP_ADDRESSES' );
exec dbms_stats.gather_table_stats( user, 'IOT_ADDRESSES' );

set lines 150
set autotrace traceonly
--
select *
from emp, heap_addresses
where emp.empno = heap_addresses.empno
and emp.empno = 42;

select *
from emp, iot_addresses
where emp.empno = iot_addresses.empno
and emp.empno = 42;
--
set autotrace off;
