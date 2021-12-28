-- Statistics for On Commit Delete Rows

set echo on

drop table gt;

create global temporary table gt(x number) on commit delete rows;

insert into gt select user_id from all_users;

exec dbms_stats.gather_table_stats(user,'GT');

select count(*) from gt;

column table_name format a20

select table_name, num_rows, last_analyzed, scope
from user_tab_statistics
where table_name like 'GT';
