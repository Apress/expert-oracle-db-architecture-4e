-- The Black Box Approach
-- Bitmap index will lock multiple rows example.
-- Connect as your PDB and schema.

-- Drop the table if it exists.
drop table t purge;

create table t(processed_flag varchar2(1));
create bitmap index t_idx on t(processed_flag);
insert into t values ( 'N' );

declare
pragma autonomous_transaction;
begin
  insert into t values ( 'N' );
  commit;
end;
/

-- Should see: ORA-00060: deadlock detected while waiting for resource
