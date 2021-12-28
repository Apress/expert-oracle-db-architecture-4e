-- TIMESTAMP WITH TIME ZONE Type, second example

drop table t purge;

set echo on

create table t
  ( ts1  timestamp with time zone,
    ts2  timestamp with time zone);

insert into t (ts1, ts2)
  values ( timestamp'2014-02-27 16:02:32.212 US/Eastern',
           timestamp'2014-02-27 16:02:32.212 US/Pacific' );

select ts1-ts2 from t;
