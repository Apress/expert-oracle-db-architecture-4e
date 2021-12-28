-- When to use B*tree, colocated vs. disorganized

set echo on

drop table colocated purge;
drop table disorganized purge;

create table colocated ( x int, y varchar2(80) );

begin
  for i in 1 .. 100000
  loop
    insert into colocated(x,y)
    values (i, rpad(dbms_random.random,75,'*') );
  end loop;
end;
/

alter table colocated
add constraint colocated_pk
primary key(x);

begin
  dbms_stats.gather_table_stats( user, 'COLOCATED');
end;
/

create table disorganized
as
select x,y
from colocated
order by y;

alter table disorganized
add constraint disorganized_pk
primary key (x);

begin
  dbms_stats.gather_table_stats( user, 'DISORGANIZED');
end;
/

exec dbms_monitor.session_trace_enable;
select * from colocated where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select * from colocated where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */ * from disorganized where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */ * from disorganized where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */ * from disorganized where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */ * from disorganized where x between 20000 and 40000;
select /*+ index( disorganized disorganized_pk ) */ * from disorganized where x between 20000 and 40000;
exec dbms_monitor.session_trace_disable;
@tk "sys=no"

column index_name format a25
select a.index_name,
         b.num_rows,
         b.blocks,
         a.clustering_factor
from user_indexes a, user_tables b
where index_name in ('COLOCATED_PK', 'DISORGANIZED_PK' )
and a.table_name = b.table_name;

-- Effect of Logical I/O sidebar
exec dbms_monitor.session_trace_enable;
set arraysize 15
select * from colocated a15 where x between 20000 and 40000;
set arraysize 100
select * from colocated a100 where x between 20000 and 40000;
exec dbms_monitor.session_trace_disable;
@tk "sys=no"

exec dbms_monitor.session_trace_enable;
set arraysize 15
select /*+ index( a15 disorganized_pk ) */ *
from disorganized a15 where x between 20000 and 40000;
set arraysize 100
select /*+ index( a100 disorganized_pk ) */ *
from disorganized a100 where x between 20000 and 40000;
exec dbms_monitor.session_trace_disable;
@tk "sys=no"

-- Full scan of disorganized
exec dbms_monitor.session_trace_enable;
select * from disorganized where x between 20000 and 30000;
exec dbms_monitor.session_trace_disable;
@tk "sys=no"

-- Clustering factor
column index_name format a25
select a.index_name,
         b.num_rows,
         b.blocks,
         a.clustering_factor
from user_indexes a, user_tables b
where index_name in ('COLOCATED_PK', 'DISORGANIZED_PK' )
and a.table_name = b.table_name;

exec dbms_monitor.session_trace_enable;
select count(Y) from
 (select /*+ INDEX(COLOCATED COLOCATED_PK) */ * from colocated);
select count(Y) from
 (select /*+ INDEX(DISORGANIZED DISORGANIZED_PK) */ * from disorganized);
exec dbms_monitor.session_trace_disable;
@tk "sys=no"

set autotrace traceonly explain
select * from colocated where x between 20000 and 30000;
select * from disorganized where x between 20000 and 30000;
set autotrace off
