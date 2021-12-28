-- Nested Tables Syntax, example 3

set echo on

SELECT /*+NESTED_TABLE_GET_REFS+*/ NESTED_TABLE_ID,SYS_NC_ROWINFO$ FROM "EODA"."EMPS_NT"; 

select name
    from sys.col$
   where obj# = ( select object_id
                    from dba_objects
                   where object_name = 'DEPT_AND_EMP'
                     and owner = 'EODA' );

select /*+ nested_table_get_refs */ empno, ename
from emps_nt where ename like '%A%';

update /*+ nested_table_get_refs */ emps_nt set ename = initcap(ename);

select /*+ nested_table_get_refs */ empno, ename
from emps_nt where ename like '%a%';

select d.deptno, d.dname, emp.*
from dept_and_emp D, table(d.emps) emp;
