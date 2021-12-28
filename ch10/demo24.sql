-- Temporary Tables, example 1

set echo on

create global temporary table temp_table_session
  on commit preserve rows
  as
  select * from scott.emp where 1=0;

create global temporary table temp_table_transaction
  on commit delete rows
  as
  select * from scott.emp where 1=0;

insert into temp_table_session select * from scott.emp;
insert into temp_table_transaction select * from scott.emp;

select session_cnt, transaction_cnt
from ( select count(*) session_cnt from temp_table_session ),
( select count(*) transaction_cnt from temp_table_transaction );

commit;

select session_cnt, transaction_cnt
    from ( select count(*) session_cnt from temp_table_session ),
         ( select count(*) transaction_cnt from temp_table_transaction );

column table_name format a25
column duration format a15
select table_name, temporary, duration from user_tables;
