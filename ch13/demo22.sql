-- Multiple Partition Maintenance Operations

drop table p_table;

set echo on

create table p_table
  (a int)
  partition by range (a)
  (partition p1 values less than (1000),
   partition p2 values less than (2000));

--alter table p_table add partition p3 values less than (3000);
--alter table p_table add partition p4 values less than (4000);

alter table p_table add
  partition p3 values less than (3000),
  partition p4 values less than (4000);

drop table sales purge;

CREATE TABLE sales(
     sales_id int
    ,s_date   date)
    PARTITION BY RANGE (s_date)
    (PARTITION P2021 VALUES LESS THAN (to_date('01-jan-2022','dd-mon-yyyy')));
 
insert into sales
    select level, to_date('01-jan-2021','dd-mon-yyyy') + ceil(dbms_random.value(1,364))
    from dual connect by level < 100000;

pause;

create or replace function get_stat_val( p_name in varchar2 ) return number
    as
         l_val number;
  begin
       select b.value
       into l_val
       from v$statname a, v$mystat b
       where a.statistic# = b.statistic#
       and a.name = p_name;
       return l_val;
  end;
/

var r1 number
exec :r1 := get_stat_val('redo size');
 
var c1 number
exec :c1 := dbms_utility.get_cpu_time;
 
alter table sales split partition P2021
    into (partition Q1 values less than (to_date('01-apr-2021','dd-mon-yyyy')),
          partition Q2 values less than (to_date('01-jul-2021','dd-mon-yyyy')),
          partition Q3 values less than (to_date('01-oct-2021','dd-mon-yyyy')),
          partition Q4);
 
set serverout on
exec dbms_output.put_line(get_stat_val('redo size') - :r1);
exec dbms_output.put_line(dbms_utility.get_cpu_time - :c1);
