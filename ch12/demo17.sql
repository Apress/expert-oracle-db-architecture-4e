-- Adding or Subtracking Time from a DATE

set echo on

alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';

select dt, add_months(dt,1)
from (select to_date('29-feb-2000','dd-mon-yyyy') dt from dual );

select dt, add_months(dt,1)
from (select to_date('28-feb-2001','dd-mon-yyyy') dt from dual );

select dt, add_months(dt,1)
from (select to_date('30-jan-2001','dd-mon-yyyy') dt from dual );
 
select dt, add_months(dt,1)
from (select to_date('30-jan-2000','dd-mon-yyyy') dt from dual );

select dt, dt+numtoyminterval(1,'month')
from (select to_date('29-feb-2000','dd-mon-yyyy') dt from dual );
 
select dt, dt+numtoyminterval(1,'month')
from (select to_date('28-feb-2001','dd-mon-yyyy') dt from dual );

select dt, dt+numtoyminterval(1,'month')
from (select to_date('30-jan-2001','dd-mon-yyyy') dt from dual );
 
select dt, dt+numtoyminterval(1,'month')
from (select to_date('30-jan-2000','dd-mon-yyyy') dt from dual );
