-- Heap Organized Tables, example 2

set long 100000
set pages 100

drop table t purge;

set echo on

create table t
    ( x int primary key,
      y date,
      z clob);

select dbms_metadata.get_ddl( 'TABLE', 'T' ) from dual;
