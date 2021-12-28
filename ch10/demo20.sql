-- Nested Tables Syntax, example 1

set echo on

drop table emp cascade constraints;
drop table dept cascade constraints; 
drop table dept_and_emp;
drop type emp_tab_type;
drop type emp_type;

create table dept
  (deptno number(2) primary key,
   dname     varchar2(14),
   loc       varchar2(13)
);

create table emp
  (empno       number(4) primary key,
   ename       varchar2(10),
   job         varchar2(9),
   mgr         number(4) references emp,
   hiredate    date,
   sal         number(7, 2),
   comm        number(7, 2),
   deptno      number(2) references dept
);

create or replace type emp_type
  as object
  (empno       number(4),
   ename       varchar2(10),
   job         varchar2(9),
   mgr         number(4),
   hiredate    date,
   sal         number(7, 2),
   comm        number(7, 2)
 );
/

create or replace type emp_tab_type
  as table of emp_type
/

create table dept_and_emp
  (deptno number(2) primary key,
   dname     varchar2(14),
   loc       varchar2(13),
   emps      emp_tab_type
)
nested table emps store as emps_nt;

alter table emps_nt add constraint
emps_empno_unique unique(empno);

alter table emps_nt add constraint mgr_fk
    foreign key(mgr) references emps_nt(empno);

insert into dept_and_emp
  select dept.*,
     CAST( multiset( select empno, ename, job, mgr, hiredate, sal, comm
                     from SCOTT.EMP
                     where emp.deptno = dept.deptno ) AS emp_tab_type )
  from SCOTT.DEPT;
