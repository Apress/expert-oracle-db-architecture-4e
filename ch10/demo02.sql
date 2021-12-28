-- Heap Organized Tables, example 1

drop table t purge;

set echo on

create table t
  ( a int,
    b varchar2(4000) default rpad('*',4000,'*'),
    c varchar2(3000) default rpad('*',3000,'*')
  );

insert into t (a) values ( 1);
insert into t (a) values ( 2);
insert into t (a) values ( 3);
select a from t;
delete from t where a = 2 ;
insert into t (a) values ( 4);
select a from t;
