-- Measuring Redo
-- Set database in noarchivelog mode for this example.

set echo on

set autotrace traceonly statistics;
truncate table t;
--
insert into t
select * from big_table;

truncate table t;

insert /*+ APPEND */ into t
select * from big_table;
