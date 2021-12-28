-- Indexing Extended Columns, Virtual Column

drop table t purge;

set echo on lines 132

create table t(x varchar2(32767));

create index ti on t(x);

insert into t select to_char(level)|| rpad('abc',10000,'xyz')
from dual connect by level < 1001
union
select to_char(level)
from dual connect by level < 1001;

alter table t add (xv as (substr(x,1,10)));
create index te on t(xv);
exec dbms_stats.gather_table_stats(user,'T');

set autotrace traceonly explain
select count(*) from t where x = '800';
select count(*) from t where x >'800' and x<'900';

set autotrace off;

drop table t purge;

create table t(x varchar2(32767));

insert into t select to_char(level)|| rpad('abc',10000,'xyz')
from dual connect by level < 1001
union
select to_char(level)
from dual connect by level < 1001;

alter table t add (xv as (standard_hash(x)));
create index te on t(xv);
exec dbms_stats.gather_table_stats(user,'T');

set autotrace traceonly explain
select count(*) from t where x='300';
select count(*) from t where x >'800' and x<'900';
set autotrace off
