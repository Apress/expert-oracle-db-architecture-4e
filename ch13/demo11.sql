-- Row Movement

drop table range_example purge;

set echo on

CREATE TABLE range_example
    ( range_key_column date,
      data             varchar2(20)
    )
    PARTITION BY RANGE (range_key_column)
    ( PARTITION part_1 VALUES LESS THAN
           (to_date('01/01/2021','dd/mm/yyyy')),
      PARTITION part_2 VALUES LESS THAN
           (to_date('01/01/2022','dd/mm/yyyy'))
   );

insert into range_example
    ( range_key_column, data )
    values
    ( to_date( '15-dec-2020 00:00:00',  'dd-mon-yyyy hh24:mi:ss' ),
      'application data...' );
 
insert into range_example
    ( range_key_column, data )
    values
    ( to_date( '01-jan-2021 00:00:00', 'dd-mon-yyyy hh24:mi:ss' )-1/24/60/60,
      'application data...' );

select * from range_example partition(part_1);

pause;

update range_example set range_key_column = trunc(range_key_column)
     where range_key_column =
        to_date( '31-dec-2020 23:59:59', 'dd-mon-yyyy hh24:mi:ss' );

update range_example
       set range_key_column = to_date('01-jan-2021','dd-mon-yyyy')
      where range_key_column = to_date('31-dec-2020','dd-mon-yyyy');

pause;

select rowid
from range_example
where range_key_column = to_date('31-dec-2013','dd-mon-yyyy');

alter table range_example enable row movement;

update range_example
   set range_key_column = to_date('01-jan-2014','dd-mon-yyyy')
   where range_key_column = to_date('31-dec-2013','dd-mon-yyyy');

select rowid  from range_example
      where range_key_column = to_date('31-dec-2020','dd-mon-yyyy');
 
alter table range_example enable row movement;

update range_example
       set range_key_column = to_date('01-jan-2021','dd-mon-yyyy')
     where range_key_column = to_date('31-dec-2020','dd-mon-yyyy');
 
select rowid  from range_example
      where range_key_column = to_date('01-jan-2021','dd-mon-yyyy');

