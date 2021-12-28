-- When Should You Use a Bitmap Index?

drop table t purge;

set echo on

create table t
  ( gender not null,
    location not null,
    age_group not null,
    data
   )
   as
  select decode( round(dbms_random.value(1,2)),
  1, 'M',
  2, 'F' ) gender,
  ceil(dbms_random.value(1,50)) location,
  decode( round(dbms_random.value(1,5)),
  1,'18 and under',
  2,'19-25',
  3,'26-30',
  4,'31-40',
  5,'41 and over'),
  rpad( '*', 20, '*')
from dual connect by level <=100000;

create bitmap index gender_idx on t(gender);
create bitmap index location_idx on t(location);
create bitmap index age_group_idx on t(age_group);

exec dbms_stats.gather_table_stats( user, 'T');

set lines 132
set autotrace traceonly explain

select count(*)
from t
where gender = 'M'
and location in ( 1, 10, 30 )
and age_group = '41 and over';

select *
from t
where (( gender = 'M' and location = 20 )
          or ( gender = 'F' and location = 22 ))
and age_group = '18 and under';
