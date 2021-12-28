-- Script name: creeoda.sql
-- Define the PDB you want to connect to in your database.
-- If you're using a non-container database, then leave the PDB variable blank.
-- But you really should be using a container database going forward.

define PDB=PDB1

connect / as sysdba

-- Switch containers to the PDB
alter session set container=&&PDB;

define username=eoda
define usernamepwd=foo
create user &&username identified by &&usernamepwd;
grant dba to &&username;
grant execute on dbms_stats      to &&username;
grant select  on sys.V_$STATNAME to &&username;
grant select  on sys.V_$MYSTAT   to &&username;
grant select  on sys.V_$LATCH    to &&username;
grant select  on sys.V_$TIMER    to &&username;
conn &&username/&&usernamepwd@&&PDB
show user
