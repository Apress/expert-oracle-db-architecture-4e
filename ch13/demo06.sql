-- Interval Partition

-- Create this tablespace if it doesn't already exist.
create tablespace example datafile size 1m autoextend on next 1m;

drop table audit_trail purge;

set echo on

create table audit_trail
  ( ts    timestamp,
    data  varchar2(30)
  )
  partition by range(ts)
  interval (numtoyminterval(1,'month'))
  store in (users, example)
  (partition p0 values less than
  (to_date('01-01-1900','dd-mm-yyyy'))
);

pause
column partition_name  format a10
column tablespace_name format a10
column high_value      format a31
column interval        format a30

select a.partition_name, a.tablespace_name, a.high_value,
  decode( a.interval, 'YES', b.interval ) interval
from user_tab_partitions a, user_part_tables b
where a.table_name = 'AUDIT_TRAIL'
and a.table_name = b.table_name
order by a.partition_position;

pause

insert into audit_trail (ts,data) values ( to_timestamp('27-feb-2020','dd-mon-yyyy'), 'xx' );

select a.partition_name, a.tablespace_name, a.high_value,
  decode( a.interval, 'YES', b.interval ) interval
from user_tab_partitions a, user_part_tables b
where a.table_name = 'AUDIT_TRAIL'
and a.table_name = b.table_name
order by a.partition_position;

set lines 132
column greater_than_eq_to format a32
column strictly_less_than format a32

select TIMESTAMP' 2020-03-01 00:00:00'-NUMTOYMINTERVAL(1,'MONTH') greater_than_eq_to,
       TIMESTAMP' 2020-03-01 00:00:00' strictly_less_than
from dual;

pause
 
insert into audit_trail (ts,data) values ( to_date('25-jun-2020','dd-mon-yyyy'), 'xx' );

select a.partition_name, a.tablespace_name, a.high_value,
  decode( a.interval, 'YES', b.interval ) interval
from user_tab_partitions a, user_part_tables b
where a.table_name = 'AUDIT_TRAIL'
and a.table_name = b.table_name
order by a.partition_position;

insert into audit_trail (ts,data) values ( to_date('15-mar-2020','dd-mon-yyyy'), 'xx' );

select a.partition_name, a.tablespace_name, a.high_value,
         decode( a.interval, 'YES', b.interval ) interval
from user_tab_partitions a, user_part_tables b
where a.table_name = 'AUDIT_TRAIL'
and a.table_name = b.table_name
order by a.partition_position;

declare
      l_str varchar2(4000);
begin
     for x in ( select a.partition_name, a.tablespace_name, a.high_value
                  from user_tab_partitions a
                  where a.table_name = 'AUDIT_TRAIL'
                  and a.interval = 'YES'
                  and a.partition_name like 'SYS\_P%' escape '\' )
     loop
          execute immediate
         'select to_char( ' || x.high_value ||
             '-numtodsinterval(1,''second''), ''"PART_"yyyy_mm'' ) from dual'
            into l_str;
          execute immediate
          'alter table audit_trail rename partition "' ||
              x.partition_name || '" to "' || l_str || '"';
     end loop;
end;
/

column partition_name format a20
select a.partition_name, a.tablespace_name, a.high_value,
  decode( a.interval, 'YES', b.interval ) interval
from user_tab_partitions a, user_part_tables b
where a.table_name = 'AUDIT_TRAIL'
and a.table_name = b.table_name
order by a.partition_position;
