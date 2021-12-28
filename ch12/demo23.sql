-- TIMESTAMP WITH TIME ZONE Type

drop table t purge;

set echo on

create table t
  (
    ts    timestamp,
    ts_tz timestamp with time zone);

insert into t ( ts, ts_tz ) values ( systimestamp, systimestamp );

set lines 132
col ts form a35
col ts_tz form a35

select * from t;

col dump format a60

select dump(ts) dump, dump(ts_tz) dump from t;
