-- Private Temporary Tables
-- temp_undo_enabled=false

alter session set temp_undo_enabled=false;

drop table perm purge;
drop table ora$ptt_temp purge;
 
create table perm
  ( x char(2000) ,
    y char(2000) ,
    z char(2000)  );

CREATE PRIVATE TEMPORARY TABLE ora$ptt_temp
  ( x char(2000) ,
    y char(2000) ,
    z char(2000))
ON COMMIT PRESERVE DEFINITION;

set serveroutput on format wrapped
begin
      do_sql( 'insert into perm
               select 1,1,1
               from all_objects
               where rownum <= 500' );

      do_sql( 'insert into ora$ptt_temp
               select 1,1,1
               from all_objects
               where rownum <= 500' );
      dbms_output.new_line;

      do_sql( 'update perm set x = 2' );
      do_sql( 'update ora$ptt_temp set x = 2' );
      dbms_output.new_line;

      do_sql( 'delete from perm' );
      do_sql( 'delete from ora$ptt_temp' );
end;
/
