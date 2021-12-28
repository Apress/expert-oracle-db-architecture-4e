-- DATE Type

drop table t purge;

set echo on

create table t ( x date );

insert into t (x) values
( to_date( '25-jun-2005 12:01:00',
  'dd-mon-yyyy hh24:mi:ss' ) );

column d format a40

select x, dump(x,10) d from t;

insert into t (x) values
  ( to_date( '01-jan-4712bc',
             'dd-mon-yyyybc hh24:mi:ss' ) );

select x, dump(x,10) d from t;
 
insert into t (x) values
  ( to_date( '01-jan-4710bc',
             'dd-mon-yyyybc hh24:mi:ss' ) );
 
select x, dump(x,10) d from t;
