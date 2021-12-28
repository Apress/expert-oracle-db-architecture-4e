-- Range Partitioning

drop table range_example purge;

set echo on

CREATE TABLE range_example
    ( range_key_column date NOT NULL,
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
    ( to_date( '15-dec-2020 00:00:00',
               'dd-mon-yyyy hh24:mi:ss' ),
      'application data...' );

insert into range_example
    ( range_key_column, data )
    values
    ( to_date( '31-dec-2020 23:59:59',
               'dd-mon-yyyy hh24:mi:ss' ),
      'application data...' );

insert into range_example
    ( range_key_column, data )
    values
    ( to_date( '01-jan-2021 00:00:00',
               'dd-mon-yyyy hh24:mi:ss' ),
      'application data...' );

insert into range_example
    ( range_key_column, data )
    values
    ( to_date( '31-dec-2021 23:59:59',
               'dd-mon-yyyy hh24:mi:ss' ),
      'application data...' );

-- should throw an error
insert into range_example
    ( range_key_column, data )
    values
    ( to_date( '01-jan-2022 00:00:00',
               'dd-mon-yyyy hh24:mi:ss' ),
      'application data...' );

select to_char(range_key_column,'dd-mon-yyyy hh24:mi:ss')
from range_example partition (part_1);

select to_char(range_key_column,'dd-mon-yyyy hh24:mi:ss')
from range_example partition (part_2);

drop table range_example purge;

CREATE TABLE range_example
    ( range_key_column date,
      data             varchar2(20)
    )
    PARTITION BY RANGE (range_key_column)
    ( PARTITION part_1 VALUES LESS THAN
           (to_date('01/01/2021','dd/mm/yyyy')),
      PARTITION part_2 VALUES LESS THAN
           (to_date('01/01/2022','dd/mm/yyyy')),
     PARTITION part_3 VALUES LESS THAN
          (MAXVALUE)
   );
