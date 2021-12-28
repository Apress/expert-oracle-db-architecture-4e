-- Solving Problems Simply
-- Define PDB that Scott user exists in.
define PDB=high

set echo on

drop profile one_session;

create profile one_session limit sessions_per_user 1;

alter user scott profile one_session;

alter system set resource_limit=true;

connect scott/F00bar_F00bar@&&PDB

host sqlplus scott/F00bar_F00bar@&&PDB
