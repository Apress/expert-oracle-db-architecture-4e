-- Shared Statistics

set echo on

drop table gt;

create global temporary table gt(x number) on commit preserve rows;

insert into gt select user_id from all_users;

exec dbms_stats.set_table_prefs(user, 'GT','GLOBAL_TEMP_TABLE_STATS','SHARED');

exec dbms_stats.gather_table_stats( user, 'GT' );

column table_name format a20

select table_name, num_rows, last_analyzed, scope
from user_tab_statistics
where table_name like 'GT';

pause

exec dbms_stats.delete_table_stats( user, 'GT' );

select table_name, num_rows, last_analyzed, scope
from user_tab_statistics
where table_name like 'GT';
