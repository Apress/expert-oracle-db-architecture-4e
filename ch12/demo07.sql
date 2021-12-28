-- NUMBER Type Syntax and Usage

drop table t purge;

set echo on

create table t ( num_col number(5,0) );
insert into t (num_col) values ( 12345 );
insert into t (num_col) values ( 123456 );
