-- Why Isn't My Index Getting Used?
-- Case 1

drop table t purge;

set echo on lines 132

create table t
  as
  select decode(mod(rownum,2), 0, 'M', 'F' ) gender, all_objects.*
  from all_objects;
 
create index t_idx on t(gender,object_id);
exec dbms_stats.gather_table_stats( user, 'T' );

set autotrace traceonly explain
select * from t t1 where object_id = 42;
set autotrace off

update t set gender =  chr(mod(rownum,256));
insert into t select * from t;
exec dbms_stats.gather_table_stats( user, 'T', cascade=>TRUE );

set autotrace traceonly explain
select * from t t1 where object_id = 42;
set autotrace off

update t  set gender = chr(mod(rownum,256));
  
exec dbms_stats.gather_table_stats( user, 'T', cascade=>TRUE );
set autotrace traceonly explain
select * from t t1 where object_id = 42;
