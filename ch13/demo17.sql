-- Asynchronous Global Index Maintenance

drop table partitioned purge;

set echo on

CREATE TABLE partitioned
      ( timestamp date,
        id        int
      )
      PARTITION BY RANGE (timestamp)
      (PARTITION fy_2020 VALUES LESS THAN
      (to_date('01-jan-2021','dd-mon-yyyy')),
      PARTITION fy_2021 VALUES LESS THAN
      ( to_date('01-jan-2022','dd-mon-yyyy')));

insert into partitioned partition(fy_2020)
      select to_date('31-dec-2020','dd-mon-yyyy')-mod(rownum,364), rownum
      from dual connect by level < 100000;
 
insert into partitioned partition(fy_2021)
     select to_date('31-dec-2021','dd-mon-yyyy')-mod(rownum,364), rownum
     from dual connect by level < 100000;

create index partitioned_idx_global on partitioned(timestamp) GLOBAL;

col r1 new_value r2
col b1 new_value b2
select * from
  (select b.value r1
   from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
   and a.name = 'redo size'),
  (select b.value b1
   from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
   and a.name = 'db block gets');

alter table partitioned drop partition fy_2020 update global indexes;

select * from
  (select b.value - &r2 redo_gen
   from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
   and a.name = 'redo size'),
  (select b.value - &b2 db_block_gets
   from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
   and a.name = 'db block gets');

column index_name format a25

select index_name, orphaned_entries, status from user_indexes
  where table_name='PARTITIONED';

exec dbms_part.cleanup_gidx;
