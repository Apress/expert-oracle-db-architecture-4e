-- Index Clustered Tables, example 4

set echo on

-- Run this query as SYS
--
col cluster_name form a30
col table_name form a30
--
break on cluster_name
--
select cluster_name, table_name
from user_tables
where cluster_name is not null
order by 1;
