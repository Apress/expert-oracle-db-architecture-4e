-- Runstats example

define PDB=PDB1

conn eoda/foo@&&PDB

drop table t1 purge;
drop table t2 purge;

create table t1
  as
  select * from big_table
  where 1=0;

create table t2
  as
  select * from big_table
  where 1=0;

exec runstats_pkg.rs_start;

insert into t1
  select *
  from big_table
  where rownum <= 1000000;

commit;

exec runstats_pkg.rs_middle;

begin
          for x in ( select *
                       from big_table
                      where rownum <= 1000000 )
          loop
                  insert into t2 values X;
          end loop;
          commit;
  end;
/

set serverout on;
exec runstats_pkg.rs_stop(1000000)
