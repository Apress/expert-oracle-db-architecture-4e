-- TIMESTAMP, example 2

drop table t purge;

set echo on

create table t
( dt   date,
  ts   timestamp(9)
);
 
insert into t values ( sysdate, systimestamp );
 
select dump(dt,10) dump, dump(ts,10) dump from t;

alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';
 
select * from t;

select dump(ts,16) dump from t;
 
select * from t;
select dump(ts,16) dump from t;
 
disconnect
connect eoda/foo@PDB1

select to_number('3537ac28', 'xxxxxxxx' ) from dual;

select * from t;
