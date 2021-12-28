-- Indexing Extended Columns, Function Based Index 

drop table t purge;

set echo on lines 132

create table t(x varchar2(32767));

insert into t
select to_char(level)|| rpad('abc',10000,'xyz')
from dual connect by level < 1001
union
select to_char(level)
from dual connect by level < 1001;

create index te on t(substr(x,1,10));

exec dbms_stats.gather_table_stats(user,'T');

set autotrace traceonly explain
select count(*) from t where x = '800';
select count(*) from t where x>'200' and x<'400';
set autotrace off;

drop table t purge;

create table t(x varchar2(32767));

insert into t
select to_char(level)|| rpad('abc',10000,'xyz')
from dual connect by level < 1001
union
select to_char(level)
from dual connect by level < 1001;

create index te on t(standard_hash(x));

set autotrace traceonly explain
select count(*) from t where x = '800';
set autotrace off
