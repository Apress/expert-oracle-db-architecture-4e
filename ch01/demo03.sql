-- Bind variables vs. non-bind variables example.
-- Connect to your PDB and schema.

-- Drop table if it exists. 
drop table t purge;

create table t ( x int );

-- Bind variable
create or replace procedure proc1
    as
    begin
        for i in 1 .. 10000
        loop
            execute immediate
            'insert into t values ( :x )' using i;
        end loop;
    end;
/

-- No bind variable
create or replace procedure proc2
    as
    begin
        for i in 1 .. 10000
        loop
            execute immediate
            'insert into t values ( '||i||')';
        end loop;
    end;
/

-- Ensure your schema has the runstats utility installed in it.
-- Setting up runstats is documented in the frontmatter of the book.
-- Also documented in the frontmatter, your schema needs access to:
-- V$STATNAME, V$MYSTAT, V$TIMER, and V$LATCH
-- For example:
-- As SYS: grant select on sys.v_$statname to eoda;
-- As SYS: grant select on sys.v_$mystat to eoda;
-- As SYS: grant select on sys.v_$timer to eoda;
-- As SYS: grant select on sys.v_$latch to eoda;

-- Enable output from PL/SQL to be displayed.
set serverout on 

-- Start the capture of statistics.
exec runstats_pkg.rs_start
-- Execute the bind variable example.
exec proc1 

-- Capture statistics used since start.
exec runstats_pkg.rs_middle 

-- Execute the non-bind variable example.
exec proc2

-- Capture statistics used since the middle, do the comparison, and display results.
-- Displaying statistics that are above the 9500 threshold.
-- You should see many rows of output.
exec runstats_pkg.rs_stop(9500)
