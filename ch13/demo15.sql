-- Sliding Windows and Indexes

drop table fy_2020 purge;
drop table fy_2022 purge;
drop table partitioned purge;

set echo on

CREATE TABLE partitioned
    ( timestamp date,
      id        int
    )
    PARTITION BY RANGE (timestamp)
    (
    PARTITION fy_2020 VALUES LESS THAN
    ( to_date('01-jan-2021','dd-mon-yyyy') ) ,
    PARTITION fy_2021 VALUES LESS THAN
   ( to_date('01-jan-2022','dd-mon-yyyy') ) );
  
insert into partitioned partition(fy_2020)
    select to_date('31-dec-2020','dd-mon-yyyy')-mod(rownum,360), rownum
    from dual connect by level <= 70000;
 
insert into partitioned partition(fy_2021)
select to_date('31-dec-2021','dd-mon-yyyy')-mod(rownum,360), rownum
from dual connect by level <= 70000;
  
create index partitioned_idx_local on partitioned(id) LOCAL;
create index partitioned_idx_global on partitioned(timestamp)  GLOBAL;

create table fy_2020 ( timestamp date, id int );
create index fy_2020_idx on fy_2020(id);

create table fy_2022 ( timestamp date, id int );
  
insert into fy_2022
select to_date('31-dec-2022','dd-mon-yyyy')-mod(rownum,360), rownum
from dual connect by level <= 70000;
 
create index fy_2022_idx on fy_2022(id) nologging;

alter table partitioned
    exchange partition fy_2020
    with table fy_2020
    including indexes
    without validation;
 
alter table partitioned drop partition fy_2020;

alter table partitioned add partition fy_2022  
values less than ( to_date('01-jan-2023','dd-mon-yyyy') );
  
alter table partitioned
    exchange partition fy_2022
    with table fy_2022
    including indexes
    without validation;

set lines 132
col index_name form a35
col status form a20

select index_name, status from user_indexes;

select /*+ index( partitioned PARTITIONED_IDX_GLOBAL ) */ count(*)
    from partitioned
    where timestamp between to_date( '01-mar-2022', 'dd-mon-yyyy' )
      and to_date( '31-mar-2022', 'dd-mon-yyyy' );

explain plan for select count(*)
      from partitioned
      where timestamp between to_date( '01-mar-2022', 'dd-mon-yyyy' )
      and to_date( '31-mar-2022', 'dd-mon-yyyy' );
 
select * from table(dbms_xplan.display(null,null,'BASIC +PARTITION'));
