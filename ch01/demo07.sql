-- Flashback query example.
-- Connect as your schema.
-- This example assumes you're connecting as SCOTT and have an EMP table available.
-- This example assumes that DBMS_FLASHBACK has been granted to SCOTT.
-- See the frontmatter of this book for an example of how to create SCOTT.

variable scn number
exec :scn := dbms_flashback.get_system_change_number;

col scn      form 999,999,999,999,999
col then_scn form 999,999,999,999,999
col now_scn  form 999,999,999,999,999

print scn

select count(*) from emp;

delete from emp;

select count(*) from emp;

commit;

select count(*),
       :scn then_scn,
       dbms_flashback.get_system_change_number now_scn
from emp as of scn :scn;

alter table emp enable row movement;

flashback table emp to scn :scn;

select cnt_now, cnt_then,
           :scn then_scn,
           dbms_flashback.get_system_change_number now_scn
      from (select count(*) cnt_now from emp),
           (select count(*) cnt_then from emp as of scn :scn)
/
