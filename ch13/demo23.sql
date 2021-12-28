-- Cascade Truncate

drop table order_line_items purge;
drop table orders purge;

set echo on

create table orders
    (
      order#      number primary key,
      order_date  date,
      data       varchar2(30)
    )
    PARTITION BY RANGE (order_date)
    (
      PARTITION part_2020 VALUES LESS THAN (to_date('01-01-2021','dd-mm-yyyy')) ,
    PARTITION part_2021 VALUES LESS THAN (to_date('01-01-2022','dd-mm-yyyy'))
   );
 
insert into orders values ( 1, to_date( '01-jun-2020', 'dd-mon-yyyy' ), 'xyz' );
 
insert into orders values  ( 2, to_date( '01-jun-2021', 'dd-mon-yyyy' ), 'xyz' );
 
create table order_line_items
      (
        order#      number,
        line#       number,
        data       varchar2(30),
        constraint c1_pk primary key(order#,line#),
        constraint c1_fk_p foreign key(order#) references orders on delete cascade
      )  partition by reference(c1_fk_p);
 
insert into order_line_items values ( 1, 1, 'yyy' );
 
insert into order_line_items values ( 2, 1, 'yyy' );
 
alter table orders truncate partition PART_2020 cascade;

truncate table orders cascade;
