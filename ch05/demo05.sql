-- Background processes

set echo on

column name        format a4
column description format a40

select paddr, name, description
   from v$bgprocess
   order by paddr desc;

select paddr, name, description
   from v$bgprocess
   where paddr <> '00'
   order by paddr desc;

