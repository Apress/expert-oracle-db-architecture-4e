-- SQL*PLus to generate a CSV file

select systimestamp from dual;
set verify off feedback off termout off echo off trimspool on pagesize 0 head off
set markup csv on
spo /tmp/big_table.dat
select * from big_table;
spo off;
set verify on feedback on termout on echo on
select systimestamp from dual;
