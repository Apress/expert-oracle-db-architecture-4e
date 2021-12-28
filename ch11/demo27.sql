-- Automatic indexing

exec dbms_auto_index.configure('AUTO_INDEX_MODE','IMPLEMENT');

drop table d purge;

create table d (d varchar2(30));

insert into d(d)
select trunc(dbms_random.value(1,100000))
from dual
connect by level <= 1000000;

declare
  i integer;
  j integer;
begin
for l_counter in 1..100000
loop
  begin
  select trunc(dbms_random.value(1,100000)) into i from dual;
  select distinct(d) into j from d where d = i;
  exception
  when no_data_found then
    null;
  end;
end loop;
end;
/

set long 1000000 pagesize 0
-- Default TEXT report for the last 24 hours.
select dbms_auto_index.report_activity() from dual;

select index_owner, table_name, index_name, column_name
from dba_ind_columns
where index_name like 'SYS_AI%'
and table_name='D';

