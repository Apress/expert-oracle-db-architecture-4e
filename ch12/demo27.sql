-- Creating a SecureFiles LOB and a BasicFiles LOB

drop table t purge;

set echo on

create table t
  ( id int primary key,
    txt clob)
segment creation immediate;

column column_name form a12
column securefile form a12

select column_name, securefile from user_lobs where table_name='T';

set long 10000
select dbms_metadata.get_ddl( 'TABLE', 'T' )  from dual;

col segment_name form a30
col segment_type form a10

select segment_name, segment_type from user_segments;

drop table t purge;

-- Creating a BasicFiles LOB

create table t
    ( id int primary key,
      txt clob)
    segment creation immediate
    lob(txt) store as basicfile;

select dbms_metadata.get_ddl( 'TABLE', 'T' )  from dual;

