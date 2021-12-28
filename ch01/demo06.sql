-- Multiversioning example.
-- Connect to your PDB and schema.

drop table t purge;

create table t as select username, created  from all_users;

set autoprint off
variable x refcursor;

begin
  open :x for select * from t;
end;
/

declare
pragma autonomous_transaction;
-- you could do this in another
-- sqlplus session as well, the
-- effect would be identical
begin
        delete from t;
        commit;
end;
/

col username form a25
col created form a20
set pages 100

print x
