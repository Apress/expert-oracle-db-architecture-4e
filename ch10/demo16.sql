-- Hash Clustered Tables, example 2

set echo on

drop table hashed_table;

create table hashed_table
( x number, data1 varchar2(4000), data2 varchar2(4000) )
  cluster hash_cluster(x);
