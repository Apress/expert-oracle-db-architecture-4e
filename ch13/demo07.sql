-- Reference Partitioning

drop table order_line_items purge;
drop table orders purge;

set echo on

create table orders
    (
      order#      number primary key,
      order_date  date,
      data       varchar2(30)
    )
    enable row movement
    PARTITION BY RANGE (order_date)
    (
     PARTITION part_2020 VALUES LESS THAN (to_date('01-01-2021','dd-mm-yyyy')) ,
     PARTITION part_2021 VALUES LESS THAN (to_date('01-01-2022','dd-mm-yyyy'))
   ); 

insert into orders values (1, to_date( '01-jun-2020', 'dd-mon-yyyy' ), 'xxx' );
insert into orders values (2, to_date( '01-jun-2021', 'dd-mon-yyyy' ), 'xxx' );

create table order_line_items
    (
      order#      number,
      line#       number,
      order_date  date, -- manually copied from ORDERS!
      data       varchar2(30),
      constraint c1_pk primary key(order#,line#),
      constraint c1_fk_p foreign key(order#) references orders
    )
   enable row movement
   PARTITION BY RANGE (order_date)
   (
     PARTITION part_2020 VALUES LESS THAN (to_date('01-01-2021','dd-mm-yyyy')) ,
     PARTITION part_2021 VALUES LESS THAN (to_date('01-01-2022','dd-mm-yyyy'))
   ); 

insert into order_line_items values ( 1, 1, to_date( '01-jun-2020', 'dd-mon-yyyy' ), 'yyy' );
insert into order_line_items values ( 2, 1, to_date( '01-jun-2021', 'dd-mon-yyyy' ), 'yyy' );

alter table order_line_items drop partition part_2020;
alter table orders drop partition part_2020;

------------------------------------------------------

drop table order_line_items cascade constraints;

truncate table orders;

insert into orders values ( 1, to_date( '01-jun-2020', 'dd-mon-yyyy' ), 'xxx' );
insert into orders values ( 2, to_date( '01-jun-2021', 'dd-mon-yyyy' ), 'xxx' );

create table order_line_items
    (
      order#      number,
      line#       number,
      data       varchar2(30),
      constraint c1_pk primary key(order#,line#),
      constraint c1_fk_p foreign key(order#) references orders
    )
    enable row movement
   partition by reference(c1_fk_p); 

insert into order_line_items values ( 1, 1, 'yyy' );
insert into order_line_items values ( 2, 1, 'yyy' );

column table_name format a20
column partition_name format a20

select table_name, partition_name
from user_tab_partitions
where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
order by table_name, partition_name;

pause

alter table orders drop partition part_2020 update global indexes;

select table_name, partition_name
from user_tab_partitions
where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
order by table_name, partition_name;

alter table orders add partition
    part_2022 values less than
    (to_date( '01-01-2023', 'dd-mm-yyyy' ));

select table_name, partition_name
from user_tab_partitions
where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
order by table_name, partition_name;

pause

select '2021', count(*) from order_line_items partition(part_2021)
union all
select '2022', count(*) from order_line_items partition(part_2022);

update orders set order_date = add_months(order_date,12);

select '2021', count(*) from order_line_items partition(part_2021)
union all
select '2022', count(*) from order_line_items partition(part_2022);

