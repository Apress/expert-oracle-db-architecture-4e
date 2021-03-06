-- Optimistic Locking Using a Checksum

set echo on

alter table dept drop column last_mod;

variable deptno number
variable dname  varchar2(14)
variable loc    varchar2(13)
variable hash   number

begin
  select deptno, dname, loc,
         ora_hash( dname || '/' || loc ) hash
    into :deptno, :dname, :loc, :hash
    from dept
   where deptno = 10;
  end;
/

column ":deptno" format 99999999
column ":dname"  format a15
column ":loc"    format a20

select :deptno, :dname, :loc, :hash
from dual;

exec :dname := lower(:dname);

update dept
     set dname = :dname
   where deptno = :deptno
     and ora_hash( dname || '/' || loc ) = :hash
/
 
select dept.*,
       ora_hash( dname || '/' || loc ) hash
   from dept
   where deptno = :deptno;

update dept
     set dname = :dname
   where deptno = :deptno
     and ora_hash( dname || '/' || loc ) = :hash
/

alter table dept
  add hash as
  ( ora_hash(dname || '/' || loc ) );

select * from dept where deptno = :deptno;
