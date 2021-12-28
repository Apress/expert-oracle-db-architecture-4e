-- TIMESTAMP

drop table t purge;

set echo on

 create table t
( dt   date,
  ts   timestamp(0)
);
 
insert into t values ( sysdate, systimestamp );
 
col dump form a45

select dump(dt,10) dump, dump(ts,10) dump from t;
