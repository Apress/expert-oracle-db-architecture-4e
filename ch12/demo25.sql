-- TIMESTAMP WITH LOCAL TIME ZONE Type

drop table t purge;

set echo on

create table t
  ( dt   date,
    ts1  timestamp with time zone,
    ts2  timestamp with local time zone);

insert into t (dt, ts1, ts2)
  values ( timestamp'2014-02-27 16:02:32.212 US/Pacific',
           timestamp'2014-02-27 16:02:32.212 US/Pacific',
           timestamp'2014-02-27 16:02:32.212 US/Pacific' );

col dbtimezone form a12
select dbtimezone from dual;

select dump(dt), dump(ts1), dump(ts2) from t;

select ts1, ts2 from t;
