-- Increased Availability

drop table emp purge;

set echo on

-- This example uses Oracle Managed Files, adjust if you don't use OMF.

alter system set db_create_file_dest='/opt/oracle/oradata';

drop tablespace p1 including contents and datafiles;
drop tablespace p2 including contents and datafiles;

create tablespace p1 datafile size 1m autoextend on next 1m;
create tablespace p2 datafile size 1m autoextend on next 1m;

CREATE TABLE emp
  ( empno   int,
    ename   varchar2(20)
  )
PARTITION BY HASH (empno)
  ( partition part_1 tablespace p1,
    partition part_2 tablespace p2
  )
/

insert into emp select empno, ename from scott.emp;

select * from emp partition(part_1);
select * from emp partition(part_2);

alter tablespace p1 offline;
select * from emp;

variable n number
exec :n := 7844;
select * from emp where empno = :n;

alter tablespace p1 online;
