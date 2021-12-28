-- Index Key Compression

set echo on

drop table t;
drop table idx_stats;

create table t
as
select * from all_objects
where rownum <= 50000;

create index t_idx on
t(owner,object_type,object_name);

analyze index t_idx validate structure;

create table idx_stats
  as
  select 'noncompressed' what, a.*
from index_stats a;

-----------------------------------------------
-- Run this section of code with values 1, 2, and 3
drop index t_idx;
create index t_idx on
t(owner,object_type,object_name)
compress &1;
analyze index t_idx validate structure;
insert into idx_stats
select 'compress &1', a.*
from index_stats a;
-----------------------------------------------

select what, height, lf_blks, br_blks,
btree_space, opt_cmpr_count, opt_cmpr_pctsave
from idx_stats;

-- Reverse Key Indexes

select 90101, dump(90101,16) from dual
union all
select 90102, dump(90102,16) from dual
union all
select 90103, dump(90103,16) from dual;
