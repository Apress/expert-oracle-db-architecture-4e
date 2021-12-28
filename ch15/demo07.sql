-- Data Pump Unload

create or replace directory tmp as '/tmp';

drop table all_objects_unload purge;

create table all_objects_unload
  organization external
  ( type oracle_datapump
    default directory TMP
    location( 'allobjects.dat' )
  )
  as
  select
  *
  from all_objects
/

set serverout on long 100000 pages 100
select dbms_metadata.get_ddl( 'TABLE', 'ALL_OBJECTS_UNLOAD' ) from dual;
