-- Segment

drop table t purge;

create table t ( x int primary key, y clob, z blob );
select segment_name, segment_type from user_segments;

-- Segment, example 2

drop table t purge;

create table t
  ( x int primary key,
    y clob,
    z blob )
SEGMENT CREATION IMMEDIATE;

column segment_name format a30
column segment_type format a20

select segment_name, segment_type
from user_segments;
