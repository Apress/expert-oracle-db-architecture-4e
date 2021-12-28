-- Partial Indexes

drop table p_table purge;

set echo on

CREATE TABLE p_table (a int)
  PARTITION BY RANGE (a)
  (PARTITION part_1 VALUES LESS THAN(1000) INDEXING ON,
   PARTITION part_2 VALUES LESS THAN(2000) INDEXING OFF);

create index pi1 on p_table(a) local indexing partial;

col index_name form a25
col partition_name form a25

select a.index_name, a.partition_name, a.status
  from user_ind_partitions a, user_indexes b
  where b.table_name = 'P_TABLE'
  and a.index_name = b.index_name;

insert into p_table select rownum from dual connect by level < 2000;

exec dbms_stats.gather_table_stats(user,'P_TABLE');

explain plan for select * from p_table where a = 20;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

explain plan for select * from p_table where a = 1500;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

alter index pi1 rebuild partition part_2;

explain plan for select * from p_table where a = 1500;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));
