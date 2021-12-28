-- DEFERRABLE Constraints and Cascading Updates, example 2

drop table t purge;

set echo on

create table t
  ( x int constraint x_not_null not null deferrable,
    y int constraint y_not_null not null,
    z varchar2(30)
);

insert into t(x,y,z)
  select rownum, rownum, rpad('x',30,'x')
  from all_users;

exec dbms_stats.gather_table_stats( user, 'T' );
create index t_idx on t(y);

explain plan for select count(*) from t;
select * from table(dbms_xplan.display(null,null,'BASIC'));

drop index t_idx;
create index t_idx on t(x);

explain plan for select count(*) from t;
select * from table(dbms_xplan.display(null,null,'BASIC'));

alter table t drop constraint x_not_null;
alter table t modify x constraint x_not_null not null;

explain plan for select count(*) from t;
select * from table(dbms_xplan.display(null,null,'BASIC'));
