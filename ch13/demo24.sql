-- Cascade Exchange

drop table c_2022 purge;
drop table part_2022 purge;

drop table order_line_items purge;
drop table orders purge;

set echo on

create table orders
      ( order#      number primary key,
        order_date  date,
        data        varchar2(30))
      PARTITION BY RANGE (order_date)
      (PARTITION part_2020 VALUES LESS THAN (to_date('01-01-2021','dd-mm-yyyy')) ,
       PARTITION part_2021 VALUES LESS THAN (to_date('01-01-2022','dd-mm-yyyy')));
 
insert into orders values (1, to_date( '01-jun-2014', 'dd-mon-yyyy' ), 'xyz'); 
insert into orders values (2, to_date( '01-jun-2015', 'dd-mon-yyyy' ), 'xyz');
 
create table order_line_items
        (order#      number,
          line#       number,
          data       varchar2(30),
          constraint c1_pk primary key(order#,line#),
          constraint c1_fk_p foreign key(order#) references orders
        ) partition by reference(c1_fk_p);
 
insert into order_line_items values ( 1, 1, 'yyy' ); 
insert into order_line_items values ( 2, 1, 'yyy' );


alter table orders add partition part_2022  values less than (to_date('01-01-2023','dd-mm-yyyy')); 

create table part_2022
      ( order#      number primary key,
        order_date  date,
        data        varchar2(30));
 
insert into part_2022 values (3, to_date('01-jun-2022', 'dd-mon-yyyy' ), 'xyz');
 
create table c_2022
        (order#      number,
         line#       number,
         data       varchar2(30),
         constraint ce1_pk primary key(order#,line#),
         constraint ce1_fk_p foreign key(order#) references part_2022);
 
insert into c_2022 values(3, 1, 'xyz'); 
 
alter table orders
      exchange partition part_2022
      with table part_2022
      without validation
      CASCADE
      update global indexes; 
