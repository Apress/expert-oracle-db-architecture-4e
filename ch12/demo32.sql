drop table t purge;

create table t (
  id         number generated always as identity,
  json_data  json,
  constraint t_pk primary key (id)
);

declare
  l_varchar2  varchar2(32767);
  l_clob      clob;
  l_blob      blob;
begin
  l_varchar2 := '{"car":"tesla","quantity":100}';
  l_clob     := '{"car":"chevy","quantity":2}';
  l_blob     := utl_raw.cast_to_raw('{"car":"volvo","quantity":10}');
  --
  insert into t (json_data) values (json(l_varchar2));
  insert into t (json_data) values (json(l_clob));
  insert into t (json_data) values (json(l_blob));
end;
/

set linesize 300

column json_data format a84

select * from t;

set linesize 300

column json_data format a30

select id, json_serialize(json_data) as json_data from t;

select t.id,
 json_value(t.json_data, '$.car') as car,
 json_value(t.json_data, '$.quantity' returning number) as quanity
from t;
