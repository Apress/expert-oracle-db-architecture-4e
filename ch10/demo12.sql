-- Index Clustered Tables, example 2

delete from emp;
delete from dept;

set echo on

insert into dept
  ( deptno, dname, loc )
  select deptno+r, dname, loc
  from scott.dept,
(select level r from dual connect by level < 10);

insert into emp
(empno, ename, job, mgr, hiredate, sal, comm, deptno)
 select rownum, ename, job, mgr, hiredate, sal, comm, deptno+r
 from scott.emp,
(select level r from dual connect by level < 10),
(select level r2 from dual connect by level < 8);

select min(count(*)), max(count(*)), avg(count(*))
from dept
group by dbms_rowid.rowid_block_number(rowid);

select *
    from (
  select dept_blk, emp_blk,
         case when dept_blk <> emp_blk then '*' end flag,
             deptno
    from (
  select dbms_rowid.rowid_block_number(dept.rowid) dept_blk,
         dbms_rowid.rowid_block_number(emp.rowid) emp_blk,
         dept.deptno
  from emp, dept
  where emp.deptno = dept.deptno
         )
             )
where flag = '*'
order by deptno;
