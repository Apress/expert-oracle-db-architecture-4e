-- Adding or Subtracting Time to/from a TIMESTAMP

set echo on

set lines 132

alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';

col ts form a40
col dt form a40
select systimestamp ts, systimestamp+1 dt
from dual;

select systimestamp ts, systimestamp +numtodsinterval(1,'day') dt
from dual;
