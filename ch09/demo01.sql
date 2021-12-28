-- What is Undo?, example 1

drop table t purge;

set echo on

create table t
  as
  select *
  from all_objects
  where 1=0;

select * from t;

set autotrace traceonly statistics
select * from t;
set autotrace off

insert into t select * from all_objects;
rollback;
select * from t;
set autotrace traceonly statistics
select * from t;
set autotrace off
