-- Do Nulls and Indexes Work Together? Example 2

drop table t purge;

set echo on

create table t ( x int, y int NOT NULL );
create unique index t_idx on t(x,y);
insert into t values ( 1, 1 );
insert into t values ( NULL, 1 );

begin
    dbms_stats.gather_table_stats(user,'T');
end;
/

set autotrace on
select * from t where x is null;
set autotrace off
