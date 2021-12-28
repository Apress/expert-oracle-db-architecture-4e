-- DATE Type, second example

drop table t purge;

set echo on

create table t ( what varchar2(10), x date );

insert into t (what, x) values
  ( 'orig',
    to_date( '25-jun-2005 12:01:00',
             'dd-mon-yyyy hh24:mi:ss' ) );

insert into t (what, x)
select 'minute', trunc(x,'mi') from t
union all
select 'day', trunc(x,'dd') from t
union all
select 'month', trunc(x,'mm') from t
union all
select 'year', trunc(x,'y') from t
/

column d format a40
select what, x, dump(x,10) d from t;
