-- Partitioning and Performance, Revisited

drop table t purge;

set echo on

create table t
  ( OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, DATA_OBJECT_ID,
    OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS,
    TEMPORARY, GENERATED, SECONDARY )
/*
  partition by hash(object_id)
  partitions 16
*/
  as
  select OWNER, OBJECT_NAME, SUBOBJECT_NAME, OBJECT_ID, DATA_OBJECT_ID,
    OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS,
    TEMPORARY, GENERATED, SECONDARY
   from all_objects;

create index t_idx
  on t(owner,object_type,object_name)
/*
  LOCAL
*/
;

exec dbms_stats.gather_table_stats( user, 'T' );

exec dbms_monitor.session_trace_enable;

variable o varchar2(30)
variable t varchar2(30)
variable n varchar2(30)

exec :o := 'SCOTT'; :t := 'TABLE'; :n := 'EMP';

select *
  from t
 where owner = :o
   and object_type = :t
   and object_name = :n;

select *
  from t
 where owner = :o
   and object_type = :t;

select *
  from t
 where owner = :o;

set autotrace on
select * from t where owner = :o and object_type = :t and object_name = :n;

explain plan for select * from t where owner = :o and object_type = :t and object_name = :n;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

set autotrace off;

pause;

drop index t_idx

create index t_idx
  on t(owner,object_type,object_name)
  global
  partition by hash(owner)
  partitions 16;

variable o varchar2(30)
variable t varchar2(30)
variable n varchar2(30)

exec :o := 'SCOTT'; :t := 'TABLE'; :n := 'EMP';

select *
  from t
 where owner = :o
   and object_type = :t
   and object_name = :n;

set autotrace on
select * from t where owner = :o and object_type = :t and object_name = :n;

explain plan for select * from t where owner = :o and object_type = :t and object_name = :n;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

set autotrace off;
