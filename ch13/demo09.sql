-- Virtual Column Partitioning

drop table res purge;

set echo on

create table res(reservation_code varchar2(30));


drop table res;

create table res(
  reservation_code varchar2(30),
  region as
   (decode(substr(reservation_code,1,1),'A','NE'
                                       ,'C','NE'
                                       ,'B','SW'
                                       ,'D','NW')
   )
  )
  partition by list (region)
  (partition NE values('NE'),
   partition SW values('SW'),
   partition NW values('NW'));

select a.table_name, a.partition_name, a.high_value
from user_tab_partitions a, user_part_tables b
where a.table_name = 'RES'
and a.table_name = b.table_name
order by a.table_name;

pause

insert into res (reservation_code)
    select chr(64+(round(dbms_random.value(1,4)))) || level
    from dual connect by level < 10;

select 'NE', reservation_code, region from res partition(NE)
union all
select 'SW', reservation_code, region from res partition(SW)
union all
select 'NW', reservation_code, region from res partition(NW);
