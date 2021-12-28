-- Object Tables, example 2

set echo on

drop table people;

create table people of person_type
/
 
select name, type#, segcollength
   from sys.col$
   where obj# = ( select object_id
                  from user_objects
                  where object_name = 'PEOPLE' )
   and name like 'SYS\_NC\_%' escape '\'
/
insert into people(name)
select rownum from all_objects;
 
exec dbms_stats.gather_table_stats( user, 'PEOPLE' );
 
column table_name format a20
select table_name, avg_row_len from user_object_tables;
