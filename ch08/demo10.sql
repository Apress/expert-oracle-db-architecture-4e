-- Restartable Processes Require Complex Logic

drop table to_do purge;

set echo on
set serverout on

create table to_do
  as
  select distinct substr( object_name, 1,1 ) first_char
    from T
/

begin
          for x in ( select * from to_do )
          loop
              update t set last_ddl_time = last_ddl_time+1
               where object_name like x.first_char || '%';

              dbms_output.put_line( sql%rowcount || ' rows updated' );
              delete from to_do where first_char = x.first_char;

              commit;
          end loop;
  end;
/
