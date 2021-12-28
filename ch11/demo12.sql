-- MY_SOUNDEX, 2nd example

create index emp_soundex_idx on
 emp( substr(my_soundex(ename),1,6) );

exec dbms_monitor.session_trace_enable;

insert into emp NO_INDEX
(empno,ename,job,mgr,hiredate,sal,comm,deptno)
select rownum empno,
       initcap(substr(object_name,1,10)) ename,
           substr(object_type,1,9) JOB,
       rownum MGR,
       created hiredate,
       rownum SAL,
       rownum COMM,
       (mod(rownum,4)+1)*10 DEPTNO
  from all_objects
 where rownum < 10000;

exec dbms_monitor.session_trace_disable;
@tk "sys=no"
pause

disconnect
connect eoda/foo@PDB1

exec dbms_monitor.session_trace_enable;

insert into emp WITH_INDEX
(empno,ename,job,mgr,hiredate,sal,comm,deptno)
select rownum empno,
       initcap(substr(object_name,1,10)) ename,
           substr(object_type,1,9) JOB,
       rownum MGR,
       created hiredate,
       rownum SAL,
       rownum COMM,
       (mod(rownum,4)+1)*10 DEPTNO
  from all_objects
 where rownum < 10000;

exec dbms_monitor.session_trace_disable;
@tk "sys=no"
