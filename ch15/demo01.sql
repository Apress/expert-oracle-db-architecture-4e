-- Simple external table example.

DROP TABLE dept_ext;

CREATE TABLE dept_ext
       (DEPTNO     number(2),
        DNAME  varchar2(14),
        LOC      varchar2(13))
       ORGANIZATION EXTERNAL
 (default directory ext_tab_dir
   location ('dept_ext.csv')); 

select * from dept_ext;

DROP TABLE dept_ext;

CREATE TABLE dept_ext
       (DEPTNO     number(2),
        DNAME  varchar2(14),
        LOC      varchar2(13),
        CRE_DATE date)
 ORGANIZATION EXTERNAL
 (
  type ORACLE_LOADER
  default directory ext_tab_dir
  access parameters
  (
   records delimited by newline
   fields terminated by '|'
  (DEPTNO,
   DNAME,
   LOC,
   CRE_DATE char date_format date mask "mm/dd/yyyy")
  )
 location ('dept_ext.csv')
);

select * from dept_ext;
