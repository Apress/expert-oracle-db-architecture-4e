-- Composite Partitioning

drop table composite_example;

set echo on

CREATE TABLE composite_example
    ( range_key_column   date,
      hash_key_column    int,
      data               varchar2(20)
    )
    PARTITION BY RANGE (range_key_column)
    subpartition by hash(hash_key_column) subpartitions 2
    (
    PARTITION part_1
        VALUES LESS THAN(to_date('01/01/2021','dd/mm/yyyy'))
        (subpartition part_1_sub_1,
         subpartition part_1_sub_2
        ),
   PARTITION part_2
       VALUES LESS THAN(to_date('01/01/2022','dd/mm/yyyy'))
       (subpartition part_2_sub_1,
        subpartition part_2_sub_2
       )
   );

insert into composite_example
    ( range_key_column, hash_key_column, data )
    values
    ( to_date('23-feb-2020','dd-mon-yyyy'),123,'app data' );

insert into composite_example
    ( range_key_column, hash_key_column, data )
    values
    ( to_date('27-feb-2021','dd-mon-yyyy'),456,'app data' );

drop table composite_range_list_example;

CREATE TABLE composite_range_list_example
    ( range_key_column   date,
      code_key_column    int,
      data               varchar2(20)
    )
    PARTITION BY RANGE (range_key_column)
    subpartition by list(code_key_column)
    (
    PARTITION part_1
        VALUES LESS THAN(to_date('01/01/2021','dd/mm/yyyy'))
        (subpartition part_1_sub_1 values( 1, 3, 5, 7 ),
         subpartition part_1_sub_2 values( 2, 4, 6, 8 )
        ),
   PARTITION part_2
       VALUES LESS THAN(to_date('01/01/2022','dd/mm/yyyy'))
       (subpartition part_2_sub_1 values ( 1, 3 ),
        subpartition part_2_sub_2 values ( 5, 7 ),
        subpartition part_2_sub_3 values ( 2, 4, 6, 8 )
       )
   );
