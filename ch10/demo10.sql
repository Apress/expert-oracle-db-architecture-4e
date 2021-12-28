-- Index Organized Tables, example 7

drop table iot;

set echo on

create table iot
  (  x    int,
     y    date,
     z    varchar2(2000),
     constraint iot_pk primary key (x)
)
organization index
pctthreshold 10
overflow;

drop table iot;

create table iot
  (  x    int,
     y    date,
     z    varchar2(2000),
     constraint iot_pk primary key (x)
)
organization index
including y
overflow;
