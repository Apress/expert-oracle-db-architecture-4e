-- Invisible Indexes

drop table t purge;

set echo on

create table t(x int);

insert into t select round(dbms_random.value(1,10000)) from dual
connect by level <=10000;

exec dbms_stats.gather_table_stats(user,'T');

create index ti on t(x) invisible;

set autotrace traceonly explain
select * from t where x=5;

alter session set optimizer_use_invisible_indexes=true;

select * from t where x=5;

set autotrace off
