-- Nested Table Storage

set echo on

drop table dept_and_emp;

create table dept_and_emp
  (deptno number(2) primary key,
   dname     varchar2(14),
   loc       varchar2(13),
   emps      emp_tab_type
  )
nested table emps store as emps_nt;

alter table emps_nt add constraint
  emps_empno_unique unique(empno);

begin
     dbms_metadata.set_transform_param
     ( DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', false );
end;
/

set long 100000
select dbms_metadata.get_ddl( 'TABLE', 'DEPT_AND_EMP' ) from dual;

drop table dept_and_emp;

CREATE TABLE "EODA"."DEPT_AND_EMP"
  ("DEPTNO" NUMBER(2, 0),
   "DNAME"  VARCHAR2(14),
   "LOC"    VARCHAR2(13),
   "EMPS" "EMP_TAB_TYPE")
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 LOGGING
  TABLESPACE "USERS"
  NESTED TABLE "EMPS"
    STORE AS "EMPS_NT"
    ((empno NOT NULL, unique (empno), primary key(nested_table_id,empno))
    organization index compress 1 )
    RETURN AS VALUE;
