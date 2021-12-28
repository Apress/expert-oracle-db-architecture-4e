-- Blockchain tables

create blockchain table ledger
(id number,
 username varchar2(30),
 value number)
no drop until 0 days idle
no delete locked
hashing using SHA2_512 version v1;

insert into ledger values(1,'HEIDI',1);

delete from ledger

select * from user_blockchain_tables;

select column_name, data_type, hidden_column
from user_tab_cols
where table_name ='LEDGER'
order by column_id;

set serverout on
declare
  actual_rows   number;
  verified_rows number;
begin
  select count(*)
  into actual_rows
  from eoda.ledger;
  --
  dbms_blockchain_table.verify_rows(
    schema_name => 'EODA',
    table_name => 'LEDGER',
    number_of_rows_verified => verified_rows);
  dbms_output.put_line('Actual rows: ' || actual_rows || ' Verified rows: ' || verified_rows);
end;
/

set serverout on
declare
   number_rows number;
begin
   dbms_blockchain_table.delete_expired_rows('EODA','LEDGER', null, number_rows);
   dbms_output.put_line('Number of rows deleted: ' || number_rows);
end;
/

