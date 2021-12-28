-- Object Tables, example 4

set echo on

drop table people_tab;

create table people_tab
  (  name        varchar2(30) primary key,
     dob         date,
     home_city   varchar2(30),
     home_street varchar2(30),
     home_state  varchar2(2),
     home_zip    number,
     work_city   varchar2(30),
     work_street varchar2(30),
     work_state  varchar2(2),
     work_zip    number
)
/
 
create view people of person_type
  with object identifier (name)
  as
  select name, dob,
   address_type(home_city,home_street,home_state,home_zip) home_adress,
   address_type(work_city,work_street,work_state,work_zip) work_adress
   from people_tab
/
 
insert into people values ( 'Tom', '15-mar-1965',
  address_type( 'Denver', '123 Main Street', 'Co', '80202' ),
  address_type( 'Redwood', '1 Oracle Way', 'Ca', '23456' ) );

column name format a20

select name, p.home_address.city from people p;
