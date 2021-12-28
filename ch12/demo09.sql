-- NUMBER Type Syntax and Usage, third example

drop table t purge;

set echo on

create table t ( msg varchar2(10), num_col number(5,-2) );
insert into t (msg,num_col) values ( '123.45',  123.45 );
insert into t (msg,num_col) values ( '123.456', 123.456 );
select * from t;
insert into t (msg,num_col) values ( '1234567', 1234567 );
select * from t;
insert into t (msg,num_col) values ( '12345678', 12345678 );
