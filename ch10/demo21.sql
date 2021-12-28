- Nested Tables Syntax, example 2

set echo on

select deptno, dname, loc, d.emps AS employees
from dept_and_emp d
where deptno = 10;

select d.deptno, d.dname, emp.*
from dept_and_emp D, table(d.emps) emp;

select d.deptno, d.dname, emp.* from dept_and_emp D, table(d.emps) emp;

update
  table( select emps
             from dept_and_emp
                    where deptno = 10
             )
set comm = 100;

-- should throw an error
update
    table( select emps
             from dept_and_emp
               where deptno = 1
        )
  set comm = 100;
 
-- should throw an error
update
    table( select emps
             from dept_and_emp
               where deptno > 1
        )
set comm = 100;

insert into table
 ( select emps from dept_and_emp where deptno = 10 )
  values
 ( 1234, 'NewEmp', 'CLERK', 7782, sysdate, 1200, null );
 
delete from table
  ( select emps from dept_and_emp where deptno = 20 )
  where ename = 'SCOTT';
 
select d.dname, e.empno, ename, deptno
  from dept_and_emp d, table(d.emps) e
  where d.deptno in ( 10, 20 );
