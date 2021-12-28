-- NUMBER Type Syntax and Usage, fourth example

drop table t purge;

set echo on

create table t ( x number, y number );
insert into t ( x )

insert into t (x)
select to_number(rpad('9',rownum*2,'9'))
from all_objects
where rownum <= 14;

update t set y = x+1;

set numformat 99999999999999999999999999999
column v1 format 99
column v2 format 99
select x, y, vsize(x) v1, vsize(y) v2
from t order by x;
