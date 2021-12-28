-- Why Isn't My Index Getting Used?
-- Case 5

drop table t purge;

set echo on

create table t(x int);

insert into t select rownum from dual connect by level < 1000000; 

create index ti on t(x);
exec dbms_stats.gather_table_stats(user,'T');

set autotrace trace explain;
select count(*) from t where x < 50;
select count(*) from t where x < 1000000;
