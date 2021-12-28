- Temporary Tables, Session Statistics

set echo on

drop table gt;

create global temporary table gt(x number) on commit preserve rows;

insert into gt select user_id from all_users;

exec dbms_stats.gather_table_stats(user,'GT');

column table_name format a25
column last_analyzed format a14

select table_name, num_rows, last_analyzed, scope
from user_tab_statistics
where table_name like 'GT';

set autotrace on;

select count(*) from gt;

set autotrace off;
