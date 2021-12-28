-- Sorted Hash Clustered Tables

set echo on

drop table cust_orders;
drop cluster shc;

CREATE CLUSTER shc
  (
     cust_id     NUMBER,
     order_dt    timestamp SORT
  )
HASHKEYS 10000
HASH IS cust_id
SIZE  8192;

CREATE TABLE cust_orders
  (  cust_id       number,
     order_dt      timestamp SORT,
     order_number  number,
     username      varchar2(30),
     ship_addr     number,
     bill_addr     number,
     invoice_num   number
)
CLUSTER shc ( cust_id, order_dt );

set autotrace traceonly explain
variable x number
--
select cust_id, order_dt, order_number
from cust_orders
where cust_id = :x
order by order_dt;

create index job_idx on scott.emp(job);

select job, hiredate, empno
from scott.emp
where job = 'CLERK'
order by hiredate;

set autotrace off
