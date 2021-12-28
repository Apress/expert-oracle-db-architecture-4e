-- Using PGA_AGGREGATE_TARGET to Control Memory Allocation

conn eoda/foo@PDB1

set echo on

create or replace package demo_pkg
  as
          type array is table of char(2000) index by binary_integer;
          g_data array;
  end;
/

column name format a30

select a.name, to_char(b.value, '999,999,999') bytes,
         to_char(round(b.value/1024/1024,1), '99,999.9' ) mbytes
    from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
     and a.name like '%ga memory%';

set autotrace traceonly statistics;
select * from t order by 1,2,3,4;
set autotrace off;

select a.name, to_char(b.value, '999,999,999') bytes,
         to_char(round(b.value/1024/1024,1), '99,999.9' ) mbytes
    from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
     and a.name like '%ga memory%';

begin
          for i in 1 .. 200000
          loop
                  demo_pkg.g_data(i) := 'x';
          end loop;
  end;
/

select a.name, to_char(b.value, '999,999,999') bytes,
         to_char(round(b.value/1024/1024,1), '99,999.9' ) mbytes
    from v$statname a, v$mystat b
   where a.statistic# = b.statistic#
     and a.name like '%ga memory%';

set autotrace traceonly statistics;
select * from t order by 1,2,3,4;
set autotrace off;
