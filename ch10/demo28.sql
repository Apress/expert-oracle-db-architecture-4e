-- Bulk Load Automatic Statistics Gathering

set echo on

drop table gt;

create global temporary table gt on commit preserve rows
as select * from all_users;

column table_name format a20

select table_name, num_rows, last_analyzed, scope
from user_tab_statistics
where table_name like 'GT';
