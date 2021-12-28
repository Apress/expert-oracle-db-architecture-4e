-- Coping with Legacy LONG Types

set echo on

select *
from all_views
where text like '%HELLO%';

set pages 100
col table_name form a30 
col column_name form a30
select table_name, column_name
from dba_tab_columns
where data_type in ( 'LONG', 'LONG RAW' )
and owner = 'SYS'
and table_name like 'DBA%'
order by table_name;
