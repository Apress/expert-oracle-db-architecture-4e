-- Interval Reference partitioning

drop table order_line_items;
drop table orders;

set echo on

create table orders
      (order#      number primary key,
       order_date  timestamp,
       data        varchar2(30))
    PARTITION BY RANGE (order_date)
    INTERVAL (numtoyminterval(1,'year'))
   (PARTITION part_2020 VALUES LESS THAN (to_date('01-01-2021','dd-mm-yyyy')) ,
    PARTITION part_2021 VALUES LESS THAN (to_date('01-01-2022','dd-mm-yyyy')));

create table order_line_items
    ( order#      number,
      line#       number,
      data        varchar2(30),
      constraint c1_pk primary key(order#,line#),
      constraint c1_fk_p foreign key(order#) references orders)
    partition by reference(c1_fk_p);

insert into orders values (1, to_date( '01-jun-2020', 'dd-mon-yyyy' ), 'xxx');
insert into orders values (2, to_date( '01-jun-2021', 'dd-mon-yyyy' ), 'xxx');
insert into order_line_items values( 1, 1, 'yyy' );
insert into order_line_items values( 2, 1, 'yyy' );

column table_name format a25
column partition_name format a20

select table_name, partition_name from user_tab_partitions
where table_name in ( 'ORDERS', 'ORDER_LINE_ITEMS' )
order by table_name, partition_name;

pause

insert into orders values (3, to_date( '01-jun-2022', 'dd-mon-yyyy' ), 'xxx');
insert into order_line_items values (3, 1, 'zzz' );

column partition_name format a10
column table_name format a16
column interval format a25
column high_value format a31

select a.table_name, a.partition_name, a.high_value,
decode( a.interval, 'YES', b.interval ) interval
from user_tab_partitions a, user_part_tables b
where a.table_name IN ('ORDERS', 'ORDER_LINE_ITEMS')
and a.table_name = b.table_name
order by a.table_name;
