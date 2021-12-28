-- Partition Elimination Behavior

drop table partitioned_table purge;

set echo on

CREATE TABLE partitioned_table
    ( a int,
      b int,
      data char(20)
    )
    PARTITION BY RANGE (a)
    (
    PARTITION part_1 VALUES LESS THAN(2) tablespace p1,
    PARTITION part_2 VALUES LESS THAN(3) tablespace p2
   );

create index local_prefixed on partitioned_table (a,b) local;
create index local_nonprefixed on partitioned_table (b) local;

insert into partitioned_table
  select mod(rownum-1,2)+1, rownum, 'x'
  from dual connect by level <= 70000;

begin
     dbms_stats.gather_table_stats
     ( user,
      'PARTITIONED_TABLE',
       cascade=>TRUE );
end;
/

alter tablespace p2 offline;

select * from partitioned_table where a = 1 and b = 1;

pause;

set lines 132
explain plan for select * from partitioned_table where a = 1 and b = 1;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

pause

select * from partitioned_table where b = 1;

pause;

explain plan for select * from partitioned_table where b = 1;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

pause

drop index local_prefixed;

explain plan for select * from partitioned_table where a = 1 and b = 1;
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));

alter tablespace p2 online;
