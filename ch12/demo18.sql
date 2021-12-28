-- Getting the Difference Between Two DATEs

set lines 132
col dt2-dt1 form 99999999999.999999999
col months_btwn form 9999999999.99999999
col days form a30
col months form a30

set echo on

select dt2-dt1 ,
months_between(dt2,dt1) months_btwn,
numtodsinterval(dt2-dt1,'day') days,
numtoyminterval(trunc(months_between(dt2,dt1)),'month') months
from (select to_date('29-feb-2000 01:02:03','dd-mon-yyyy hh24:mi:ss') dt1,
to_date('15-mar-2001 11:22:33','dd-mon-yyyy hh24:mi:ss') dt2
from dual )
/

column years_months form a30
column days_hours form a30

select numtoyminterval
(trunc(months_between(dt2,dt1)),'month')
years_months,
numtodsinterval
(dt2-add_months( dt1, trunc(months_between(dt2,dt1)) ),
'day' )
days_hours
from (select to_date('29-feb-2000 01:02:03','dd-mon-yyyy hh24:mi:ss') dt1,
to_date('15-mar-2001 11:22:33','dd-mon-yyyy hh24:mi:ss') dt2
from dual )
/
