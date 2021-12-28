-- Index Organized Tables, example 3

set echo on

drop table t1 purge;
drop table t2 purge;
drop table t3 purge;

set echo on

create table t1
  (  x int primary key,
     y varchar2(25),
     z date
)
organization index;

create table t2
  (  x int primary key,
     y varchar2(25),
     z date
  )
organization index
OVERFLOW;

create table t3
  (  x int primary key,
     y varchar2(25),
     z date
  )
organization index
overflow INCLUDING y;

set long 100000
set pages 100

select dbms_metadata.get_ddl( 'TABLE', 'T1' ) from dual;
